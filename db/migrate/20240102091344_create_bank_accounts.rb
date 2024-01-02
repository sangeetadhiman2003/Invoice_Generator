class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.integer :account_number
      t.string :ifsc_code
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
