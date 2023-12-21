class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.integer :hour
      t.string :amount
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
