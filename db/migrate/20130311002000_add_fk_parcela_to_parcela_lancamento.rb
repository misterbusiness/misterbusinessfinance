class AddFkParcelaToParcelaLancamento < ActiveRecord::Migration
  def change
    change_table :parcela_lancamentos do |t|
      t.references :parcela
    end       
  end  
end
