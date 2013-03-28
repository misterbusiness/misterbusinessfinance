class ChangeValorScaleLancamentoRapido < ActiveRecord::Migration
  def change
    change_column :lancamentorapidos, :valor, :decimal, :precision => 9, :scale => 2 
  end
end
