class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :pan
      t.integer :phone
      t.string :state
      t.string :city
      t.string :address

      t.timestamps
    end
  end
end
