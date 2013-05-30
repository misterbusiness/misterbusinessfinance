class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.date :data
      t.integer :tipo_cd
      t.string :descricao
      t.decimal :valor

      t.timestamps
    end
  end
end
