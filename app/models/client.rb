class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy
  belongs_to :user
  has_one_attached :signature_image
  # TODO: check if we can use enum here
  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze

  # TODO: check if we can use it in single line
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
end
