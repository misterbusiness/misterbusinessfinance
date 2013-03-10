class ChangeTipoColumnNameOnLancamento < ActiveRecord::Migration
  def up
    rename_column :lancamentos, :tipo, :tipo_cd
    rename_column :lancamentos, :status, :status_cd
  end

  def down
    rename_column :lancamentos, :tipo_cd, :tipo
    rename_column :lancamentos, :status_cd, :status
  end
end
