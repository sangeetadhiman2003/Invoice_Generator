class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :rate
      t.integer :tax_value
      t.integer :gst

      t.timestamps
    end
  end
end
