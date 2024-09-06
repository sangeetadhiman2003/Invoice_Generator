class Client < ApplicationRecord
  belongs_to :user

  has_many :invoices, dependent: :destroy
  has_one_attached :signature_image
  validate :acceptable_image

  # TODO: check if we can use it in single line
  validates :name, :email, :address, :city, :state, presence: true

  # TODO: check if we can use enum here
  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze

  def acceptable_image
    return unless signature_image.attached?

    unless signature_image.blob.byte_size <= 1.megabyte
      errors.add(:signature_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(signature_image.blob.content_type)
      errors.add(:signature_image, "must be a JPEG or PNG")
    end

end
