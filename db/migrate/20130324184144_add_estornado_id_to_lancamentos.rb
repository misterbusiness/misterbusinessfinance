class AddEstornadoIdToLancamentos < ActiveRecord::Migration
    def change
    change_table :lancamentos do |t|      
      t.integer :estorno_id
    end  
  end
end
