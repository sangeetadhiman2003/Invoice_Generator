class Client < ApplicationRecord
  belongs_to :user

  has_many :invoices, dependent: :destroy
  has_one_attached :signature_image

  # TODO: check if we can use it in single line
  validates :name, :email, :address, :city, :state, presence: true

  # TODO: check if we can use enum here
  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze

end
