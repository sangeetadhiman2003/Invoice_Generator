class User < ApplicationRecord

  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze
  acts_as_paranoid
  has_many :invoices
  has_one_attached :signature_image

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :phone, length: { is: 10}

end
