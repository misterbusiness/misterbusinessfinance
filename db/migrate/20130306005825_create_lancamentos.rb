class CreateLancamentos < ActiveRecord::Migration
 def change
   create_table :lancamentos do |t|
     t.string   :descricao
     t.integer  :tipo_cd
     t.date     :datavencimento
     t.date     :dataacao
     t.decimal  :valor,            :precision => 9, :scale => 2
     t.integer  :status_cd

     t.references :category
     t.references :centrodecusto

     t.timestamps
  end
 end
end
