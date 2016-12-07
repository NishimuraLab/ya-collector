class Label < ActiveRecord::Base
  belongs_to :item, foreign_key: :auction_id
  has_many :similarities
end
