class CreateLabelsTable < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :auction_id, null: false
      t.string :label, null: false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
