require 'nokogiri'
require 'open-uri'

class GeoexpatJob < ApplicationJob
  queue_as :default

  def perform
    @css_query = '#dj-classifieds .items .gxclsf-cat-desc'
    @site = 'https://geoexpat.com'
    links = []
    url = "#{@site}/classifieds/"

    puts "Starting GeoExpat"
    page = Nokogiri::HTML(open(url))
    css_query = '.dj-category .cat_title_desc a'
    if(page.css(css_query).any?)
      page.css(css_query).each do |atag|
        links << atag['href']
      end
    else
      puts "No links found"
    end

    links.each do |relative_url|
      category = relative_url.gsub('/classifieds/','')[0..-2]
      base_url = "#{@site}#{relative_url}"
      fetch(base_url, category)
    end
  end

  def fetch base_url, category
    offset = 0
    run = true
    puts "Fetching #{base_url}..."
    while run
      url = "#{base_url}?start=#{offset}"
      page = Nokogiri::HTML(open(url))
      if(page.css(@css_query).any?)
        parse_page(page, category)
        offset+=12
      else
        puts "No more results #{offset}"
        run = false
      end
    end
  end

  def parse_page page, category
    listings = page.css(@css_query)
    listings.each do |item|
      atag = page.css("#{item.css_path} .gxclsf-cat-img a").first
      link = "https://geoexpat.com#{atag['href']}"
      listing(link, category)
    end
  end

  def listing url, category
    page = Nokogiri::HTML(open(url))
    Rails.logger.error("Listing #{url}")
    if !page.nil?
      site_id = page.css('#item_id').first['value']
      title = page.css('.dj-item .title_top h2').first.inner_text.strip
      first_image = page.css('.dj-item .djc_thumbnail a').first
      image_url = ''
      if first_image
        image_url = "#{@site}#{first_image['href']}"
      end

      price_details = page.css('.dj-item .general_det span[itemprop="price"]').first
      price = ''
      if !price_details.nil?
        price = "#{price_details.inner_text.strip.gsub('HK$', '').strip}"
      end

      description_details = page.css(".dj-item .description .desc_content").first
      description = ''
      if !description_details.nil?
        description = description_details.inner_text.strip
      end

      Item.create({
        source: "GeoExpat",
        site_id: site_id,
        title: title.strip,
        price: price.strip,
        category: category,
        description: description.strip,
        link: url,
        image_url: image_url
      })
    end
  end
end