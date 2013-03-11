class AddParcelaFkToLancamento < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.references :parcela_lancamento
    end       
  end  
end
