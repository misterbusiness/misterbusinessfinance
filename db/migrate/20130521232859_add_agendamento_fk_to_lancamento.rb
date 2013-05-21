class AddAgendamentoFkToLancamento < ActiveRecord::Migration
  def change
    change_table :lancamentos do |t|
      t.references :agendamento
    end
  end
end
