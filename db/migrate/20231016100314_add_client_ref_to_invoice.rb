class AddClientRefToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :client, foreign_key: true
  end
end
