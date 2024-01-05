class BankAccount < ApplicationRecord

  belongs_to :organization
  validates :name, :account_number, :ifsc_code, presence: true
end
