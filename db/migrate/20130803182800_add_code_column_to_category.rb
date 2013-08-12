class AddCodeColumnToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :code, :string
    add_index :categories, :code
  end

  def self.down
    remove_index :categories, :code
  end
end
