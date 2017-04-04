class Item < ApplicationRecord

  validates_presence_of :title, :price, :category, :description
  validates_uniqueness_of :site_id, :link

  scope :ordering, ->(field, direction) do
    order(:"#{field.downcase}" => :"#{direction.downcase}")
  end

  scope :order_by_latest, -> do
    ordering(:created_at, :desc)
  end

  scope :search, -> (search_text) do
    where("title LIKE :text OR description LIKE :text", text: "%#{search_text}%")
  end

  def resource_url
   Rails.application.routes.url_helpers.item_path(id)
  end

  def image
    image_url.present? ? image_url : 'http://placehold.it/240x180'
  end

end
