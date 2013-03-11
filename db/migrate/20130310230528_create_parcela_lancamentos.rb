class CreateParcelaLancamentos < ActiveRecord::Migration
  def change
    create_table :parcela_lancamentos do |t|
      t.integer :indice

      t.timestamps
    end
  end
end
