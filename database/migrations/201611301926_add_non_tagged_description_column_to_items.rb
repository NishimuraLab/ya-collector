class AddNonTaggedDescriptionColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :non_tagged_description, :text
  end
end
