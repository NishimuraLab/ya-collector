class CreateProcessedTextsTable < ActiveRecord::Migration
  def change
    create_table :processed_texts do |t|
      t.string :auction_id, index: true, null: false
      t.string :process_type, null: false
      t.text :title, null: false
      t.text :description,  limit: 4294967295, null: false
    end
  end
end
