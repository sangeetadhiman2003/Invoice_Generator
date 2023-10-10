class AddForeClientsToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :invoice, index: true, foreign_key: true
  end
end
