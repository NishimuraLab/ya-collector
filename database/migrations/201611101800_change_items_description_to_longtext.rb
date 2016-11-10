require 'active_record'

class ChangeItemsDescriptionToLongtext < ActiveRecord::Migration
  def self.up
    change_column :items, :description, :text,  limit: 4294967295
  end

  def self.down
    drop_table :items, :description, :text, limit: 65535
  end
end
