class CreateCentrodecustos < ActiveRecord::Migration
  def change
    create_table :centrodecustos do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
