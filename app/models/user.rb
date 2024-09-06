class User < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization

  has_many :clients
  has_many :invoices
  has_many :invoices , dependent: :destroy
  has_one_attached :signature_image
  validate :acceptable_image
  validates :name, :email, :address, :city, :state, presence: true
  validates :phone, length: { is: 10}

  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze
  LAYOUT_TYPE = ['Simple', 'Stylish']


  def restore_id!
    self.update(deleted_at: nil)
  end

  def name=(value)
    super(value.to_s.titleize)
  end


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
end
