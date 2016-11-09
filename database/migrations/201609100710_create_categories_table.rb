require 'active_record'

class CreateCategoriesTable < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :category_id
      t.string :category_name
      t.string :category_id_path
      t.integer :parent_category_id
      t.boolean :is_leaf, default: false, null: false
      t.integer :depth
      t.integer :order
      t.boolean :is_link, default: false, null: false
      t.integer :child_category_num
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :category_relations do |t|
      t.integer :parent_id
      t.integer :child_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :categories
    drop_table :category_relations
  end
end
