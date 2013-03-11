class RemoveFkParcelaFromLancamento < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.remove :parcela_lancamento_id
    end  
  end
end
