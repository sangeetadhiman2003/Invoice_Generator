class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :rate
      t.string :quantity
      t.integer :hours
      t.integer :gst
      t.integer :tax_value
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
