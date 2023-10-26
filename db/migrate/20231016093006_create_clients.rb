class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.integer :phone
      t.integer :email
      t.string :state
      t.string :city

      t.timestamps
    end
  end
end
