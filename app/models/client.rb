class Client < ApplicationRecord
  belongs_to :user

  has_many :invoices, dependent: :destroy
  has_one_attached :signature_image

  # TODO: check if we can use it in single line
  #checked but it is not working in single line
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true

  # TODO: check if we can use enum here
  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze

end
