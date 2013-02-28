class CreateLancamentos < ActiveRecord::Migration
  def change
    create_table :lancamentos do |t|
      t.string :descricao
      t.string :tipo
      t.datetime :datavencimento
      t.datetime :dataacao
      t.float :valor
      t.string :categoria
      t.string :centrodecusto
      t.string :status

      t.timestamps
    end
  end
end
