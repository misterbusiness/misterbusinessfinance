class AddFkToLancamentos < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.references :category
    end

    change_table :lancamentos do |t|
      t.references :costcenter
    end
	
  end     
end
