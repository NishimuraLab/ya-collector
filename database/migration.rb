require 'active_record'

class CreateItemsTable < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :auction_id
      t.integer :category_id
      t.string :category_path
      t.text :title
      t.integer :seller_id
      t.text :auction_item_url
      t.float :init_price
      t.integer :current_price
      t.integer :quantity
      t.integer :available_quantity
      t.integer :current_bids
      t.integer :highest_bidder_id
      t.integer :highest_bidder_rating_point
      t.boolean :highest_bidder_rating_is_suspended
      t.boolean :highest_bidder_rating_is_deleted
      t.text :highese_bidder_item_list_url
      t.text :highest_bidder_rating_url
      t.string :item_condition
      t.text :item_status_comment, null: true
      t.boolean :is_item_returnable, default: false, null: false
      t.text :item_returnable_comment, null: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :bidor_buy, null: true
      t.integer :tax_rate, null: true
      t.float :taxin_price, null: true
      t.float :taxin_bidor_buy, null: true
      t.integer :reserved_price, null: true
      t.boolean :is_bidder_credit_restriction, default: false, null: false
      t.boolean :is_bidder_restriction, default: false, null: false
      t.boolean :is_bidder_ratio_restriction, default: false, null: false
      t.boolean :is_early_closing, default: false, null: false
      t.boolean :is_automatic_extension, default: false, null: false
      t.boolean :is_offer, default: false, null: false
      t.boolean :is_charity, default: false, null: false
      # optionは対応しない
      t.float :easy_payment_safe_keeping_payment, null: true
      t.boolean :is_credit_card, default: false, null: false
      t.boolean :is_net_bank, default: false, null: false
      t.string :payment_bank_method, null: true
      t.
      t.text :description
      # TODO
      # payment検討
      t.string :charge_for_shipping
      t.string :location, null: true
      t.boolean :is_world_wide, default: false, null: false
      t.string :ship_time
      # TODO
      # shipping
      t.boolean :is_adult, default: false, null: false
      t.integer :charity_option_propotion, null: false
      t.integer :answered_q_and_a_num
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at
    end

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
    drop_table :items
    drop_table :categories
    drop_table :category_relations
    drop_table :images
  end
end
