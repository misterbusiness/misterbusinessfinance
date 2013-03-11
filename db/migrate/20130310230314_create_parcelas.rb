class CreateParcelas < ActiveRecord::Migration
  def change
    create_table :parcelas do |t|
      t.integer :num_parcelas

      t.timestamps
    end
  end
end
