class RemoveCategoriaFromLancamento < ActiveRecord::Migration
  def change
    remove_column :lancamentos, :categoria
    remove_column :lancamentos, :centrodecusto
  end
end
