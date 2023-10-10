class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :invoice_no
      t.string :invoice_date
      t.string :due_date
      t.text :terms_and_condition
      t.text :notes
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
