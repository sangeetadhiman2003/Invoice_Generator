class AddColToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :pan, :string
    change_column :clients, :email, :string

  end
end
