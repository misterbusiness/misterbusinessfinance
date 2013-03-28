class CreateCostcenters < ActiveRecord::Migration
  def change
    create_table :costcenters do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
