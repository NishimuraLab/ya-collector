require 'active_record'
class Item < ActiveRecord::Base
  self.primary_key = :auction_id
  has_one :label, foreign_key: :auction_id
end
