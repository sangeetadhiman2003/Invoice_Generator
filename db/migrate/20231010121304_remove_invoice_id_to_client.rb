class RemoveInvoiceIdToClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :invoice_id
  end
end
