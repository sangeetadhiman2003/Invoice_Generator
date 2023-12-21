class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  INVOICE_TYPE = ['PRODUCT', 'SERVICE'].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
