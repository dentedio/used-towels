class Item < ApplicationRecord
  # include AlgoliaSearch

  validates_presence_of :title, :price, :category, :description
  validates_uniqueness_of :site_id, :link

  # algoliasearch enqueue: :update_algolia do

  #   attributes  :title, :description, :price, :category, :resource_url

  #   # easier to deal with time this way
  #   attribute :created_at_i do
  #     created_at.to_i
  #   end

  #   attribute :item_url do
  #     self.resource_url
  #   end

  #   attributesToIndex ['title', 'description']

  #   tags do
  #     [category]
  #   end

  #   customRanking ['desc(created_at_i)']
  # end

  scope :ordering, ->(field, direction) do
    order(:"#{field.downcase}" => :"#{direction.downcase}")
  end

  scope :order_by_latest, -> do
    ordering(:created_at, :desc)
  end

  scope :search, -> (search_text) do
    where("title LIKE :text OR description LIKE :text", text: search_text)
  end

  def resource_url
   Rails.application.routes.url_helpers.item_path(id)
  end

  # def self.update_algolia record, remove
  #   AlgoliaItemJob.perform_async(record.id, remove)
  # end

end
