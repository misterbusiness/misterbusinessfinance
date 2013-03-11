class AddFkLancamentoToParcelaLancamento < ActiveRecord::Migration
  def change
    change_table :parcela_lancamentos do |t|
      t.references :lancamento
    end  
  end
end
