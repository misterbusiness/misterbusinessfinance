class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.integer :number

      t.timestamps
    end
  end
end
