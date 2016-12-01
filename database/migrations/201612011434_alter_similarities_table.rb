class AlterSimilaritiesTable < ActiveRecord::Migration
  def change
    rename_column :similarities, :auction_id, :label_id
    rename_column :similarities, :pair_auction_id, :pair_label_id

    add_index :similarities, [:label_id, :pair_label_id]
  end
end
