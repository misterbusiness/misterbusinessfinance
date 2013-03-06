class AddFkToLancamentos < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.references :category
    end       
  end     
end
