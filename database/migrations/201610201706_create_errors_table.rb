require 'active_record'

class CreateErrorsTable < ActiveRecord::Migration
  def self.up
    create_table :errors do |t|
      t.string :object_id
      t.string :object_type
      t.text :stack_trace
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :errors
  end
end
