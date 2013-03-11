class ChangeValorScale < ActiveRecord::Migration
  def change
    change_column :lancamentos, :valor, :decimal, :precision => 9, :scale => 2 
  end

end
