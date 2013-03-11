class ChangeTipoColumnToLancamento < ActiveRecord::Migration
  def up
    change_column :lancamentos, :tipo, :integer
    change_column :lancamentos, :status, :integer
  end

  def down
  end
end
