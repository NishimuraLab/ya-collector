class AddNeologdWakatiDescriptionAndTitleColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :neologd_wakati_title, :text
    add_column :items, :neologd_wakati_description, :text, limit: 16777216
  end
end
