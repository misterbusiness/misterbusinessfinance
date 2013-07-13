class AddCategoryCashFlowColumn < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.boolean :is_cash_flow
    end
  end
end
