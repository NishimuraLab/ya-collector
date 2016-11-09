require 'active_record'

class CreateImagesTable < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :item_id
      t.text :image_url
      t.text :image_alt
      t.integer :width
      t.integer :height
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :images
  end
end
