require 'active_record'

class CreateItemsTable < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :auction_id
      t.integer :category_id
      t.string :category_path
      t.text :title
      t.string :seller_id
      t.integer :seller_rating_point
      t.boolean :seller_rating_is_suspended
      t.boolean :seller_rating_is_deleted
      t.text :seller_item_list_url
      t.text :seller_rating_url
      t.text :auction_item_url
      t.float :init_price
      t.integer :current_price # Price
      t.integer :quantity
      t.integer :available_quantity
      t.integer :current_bids # Bids
      t.integer :highest_bidder_id
      t.integer :highest_bidder_rating_point
      t.boolean :highest_bidder_rating_is_suspended
      t.boolean :highest_bidder_rating_is_deleted
      t.text :highest_bidder_item_list_url
      t.text :highest_bidder_rating_url
      t.boolean :highest_bidders_is_more
      t.float :y_point
      t.string :item_status_condition
      t.text :item_status_comment, null: true
      t.boolean :item_returnable_allowed, default: false
      t.text :item_returnable_comment, null: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :bidor_buy, null: true
      t.integer :tax_rate, null: true
      t.float :taxin_price, null: true
      t.float :taxin_bidor_buy, null: true
      t.integer :reserved_price, null: true # Reserved
      t.boolean :is_bid_credit_restrictions, default: false
      t.boolean :is_bidder_restriction, default: false
      t.boolean :is_bidder_ratio_restriction, default: false
      t.boolean :is_early_closing, default: false
      t.boolean :is_automatic_extension, default: false
      t.boolean :is_offer, default: false
      t.boolean :is_charity, default: false
      t.text :description
      # optionは対応しない
      t.float :easy_payment_safe_keeping_payment, null: true
      t.boolean :easy_payment_is_credit_card, default: false
      t.boolean :easy_payment_is_net_bank, default: false
      t.string :payment_bank_method, null: true
      t.boolean :payment_cash_registration, default: false
      t.boolean :payment_postal_transfer, default: false
      t.boolean :payment_postal_order, default: false
      t.boolean :payment_cash_on_delivery, default: false
      t.boolean :payment_credit_card, default: false
      t.boolean :payment_loan, default: false
      t.string :payment_other_method, null: true
      t.string :charge_for_shipping
      t.string :location, null: true
      t.boolean :is_world_wide, default: false
      t.string :ship_time
      # shippingは対応しない
      t.integer :baggage_info_size, null: true
      t.integer :baggage_info_weight, null: true
      t.boolean :is_adult, default: false
      t.integer :charity_option_propotion
      t.integer :answered_q_and_a_num
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :items
  end
end
