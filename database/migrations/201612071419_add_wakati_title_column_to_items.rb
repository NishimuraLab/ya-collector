class AddWakatiTitleColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :wakati_title, :text
  end
end
