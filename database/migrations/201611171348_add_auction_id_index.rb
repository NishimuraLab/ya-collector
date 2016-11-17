require 'active_record'

class AddAuctionIdIndex < ActiveRecord::Migration
  def self.up
    add_index :items, :auction_id
  end

  def self.down
    remove_index :items, :auction_id
  end
end
