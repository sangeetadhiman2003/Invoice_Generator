class ChangeDataTypeToInvoiceCol < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :invoice_date, :date
  end
end
