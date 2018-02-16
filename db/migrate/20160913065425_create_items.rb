class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string  :source
      t.string  :site_id
      t.string  :title
      t.string  :category
      t.text    :description
      t.string  :link
      t.string  :price
      t.string  :image_url

      t.timestamps
    end
  end
end
