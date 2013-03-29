class ChangeTipoColumnToLancamento < ActiveRecord::Migration
  def change
    remove_column :lancamentos, :tipo
    
    add_column :lancamentos, :tipo, :integer
    add_column :lancamentos, :status, :integer
  end
end
