class CreateAgendamentos < ActiveRecord::Migration
  def change
    create_table :agendamentos do |t|
      t.integer :num_agendamentos

      t.timestamps
    end
  end
end
