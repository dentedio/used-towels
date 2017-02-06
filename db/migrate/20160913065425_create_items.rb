class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string  :site_id
      t.string  :title
      t.string  :category
      t.text    :description
      t.string  :link
      t.string  :price

      t.timestamps
    end
  end
end
