class AddAncestryToCentrodecustos < ActiveRecord::Migration
   def self.up
    add_column :centrodecustos, :ancestry, :string
    add_index :centrodecustos, :ancestry
  end
  
  def self.down
    remove_index :centrodecustos, :ancestry
  end
end
