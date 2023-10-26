class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_one_attached :signature_image
  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true


end
