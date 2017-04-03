require 'nokogiri'
require 'open-uri'

class AsiaxpatJob < ApplicationJob
  queue_as :daily

  def perform
    @css_query = '.soltop .listitem'
    @previous_first_page_link = ''
    site = 'https://hongkong.asiaxpat.com'
    links = []
    url = "#{site}/classifieds/"

    puts "Starting AsiaXpat #{url}"
    page = Nokogiri::HTML(open(url))
    css_query = '.rsb2'
    if(page.css(css_query).any?)
      page.css(css_query).each do |atag|
        links << atag['href']
      end
    else
      puts "No links found"
    end

    links.each do |relative_url|
      category = relative_url.gsub('/classifieds/','')[0..-2]
      base_url = "#{site}#{relative_url}"
      fetch(base_url, category)
    end
  end

  def fetch(base_url, category)
    offset = 1
    run = true
    puts "Fetching #{base_url}..."
    while run
      url = "#{base_url}#{offset}"
      page = Nokogiri::HTML(open(url))
      if(page.css(@css_query).any? && !is_duplicate(page))
        parse_page(page, category)
        offset+=1
      else
        puts "No more results #{offset}"
        run = false
      end
    end
  end

  def is_duplicate page
    current_first_page_link = page.css("#{@css_query} h4.R a").first['href']
    duplicate_found = @previous_first_page_link == current_first_page_link
    if !duplicate_found
      @previous_first_page_link = current_first_page_link
    end
    duplicate_found
  end

  def parse_page page, category
    sources = page.css(@css_query)
    sources.each do |item|
      atag = page.css("#{item.css_path} h4.R a").first
      link = atag['href']
      title = atag.inner_text.strip
      first_image = page.css("#{item.css_path} .fancybox img").first
      image_url = ''
      if first_image
        image_url = first_image['src']
      end

      price_details = page.css("#{item.css_path} .borderright").last
      price = price_details.children.last.inner_text.gsub("HKD", "").strip if !price_details.nil? && !price_details.children.nil?

      description = page.css("#{item.css_path} .leftlistitem").first.inner_text.strip

      Item.create({
        source: "AsiaXpat",
        site_id: "",
        title: title.strip,
        price: price.strip,
        category: category,
        description: description.strip,
        link: link,
        image_url: image_url
      })
    end
  end

end
