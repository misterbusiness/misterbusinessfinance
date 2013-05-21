class CreateLancamentorapidos < ActiveRecord::Migration
  def change
  create_table :lancamentorapidos do |t|
      t.string :descricao
      t.integer :tipo_cd
      t.integer :diavencimento
      t.decimal  :valor,            :precision => 9, :scale => 2
      t.string :categoria
      t.string :centrodecusto 
      
      t.references :category
      t.references :centrodecusto     
      
      t.timestamps
    end   
  end
end
