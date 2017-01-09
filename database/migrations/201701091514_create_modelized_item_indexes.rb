class CreateModelizedItemIndexes < ActiveRecord::Migration
  def change
    create_table :modelized_item_indexes do |t|
      t.string :auction_id, null: false, index: true
      t.text :type, null: false
    end
  end
end
