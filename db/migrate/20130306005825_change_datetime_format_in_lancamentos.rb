class ChangeDatetimeFormatInLancamentos < ActiveRecord::Migration
 def change
   change_column :lancamentos, :datavencimento, :date
   change_column :lancamentos, :dataacao, :date
  end
end
