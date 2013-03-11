class RenameDescriptionForCategory < ActiveRecord::Migration
  def change
    rename_column :categories, :description, :descricao
  end
end
