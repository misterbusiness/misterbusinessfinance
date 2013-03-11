class AddCentrodecustoFkToLancamentos < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.references :centrodecusto
    end       
  end  
end
