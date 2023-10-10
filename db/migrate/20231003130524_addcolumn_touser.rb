class AddcolumnTouser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :invoice_id, :integer

  end
end
