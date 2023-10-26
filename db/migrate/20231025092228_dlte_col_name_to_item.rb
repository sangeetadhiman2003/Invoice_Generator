class DlteColNameToItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :name
    remove_column :items, :rate
    remove_column :items, :gst
    remove_column :items, :tax_value
  end
end
