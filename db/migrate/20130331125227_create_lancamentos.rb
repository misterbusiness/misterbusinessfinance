class CreateLancamentos < ActiveRecord::Migration
  def change
    create_table :lancamentos do |t|

      t.timestamps
    end
  end
end
