class AddForeignToItem < ActiveRecord::Migration[5.0]
  def change
    rename_column :items , :invoices_id ,:invoice_id
  end
end
