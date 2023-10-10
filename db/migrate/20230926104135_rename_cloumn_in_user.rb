class RenameCloumnInUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users,:invoices_id , :invoice_id
  end
end
