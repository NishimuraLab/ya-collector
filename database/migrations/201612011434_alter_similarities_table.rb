class AlterSimilaritiesTable < ActiveRecord::Migration
  def change
    rename_column :similarities, :auction_id, :label
    rename_column :similarities, :pair_auction_id, :pair_label

    add_index :similarities, [:label, :pair_label]
  end
end
