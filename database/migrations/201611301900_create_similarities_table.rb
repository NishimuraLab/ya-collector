class CreateSimilaritiesTable < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.string :auction_id, null: false
      t.string :pair_auction_id, null: false
      t.float :degree, null: false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
