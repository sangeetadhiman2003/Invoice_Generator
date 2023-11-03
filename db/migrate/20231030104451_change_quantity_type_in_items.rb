class ChangeQuantityTypeInItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :quantity, :decimal
  end
end
