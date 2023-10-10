class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :phone
      t.string :pan
      t.string :address
      t.string :city
      t.string :state
      t.string :email

      t.timestamps
    end
  end
end
