class User < ApplicationRecord

  acts_as_paranoid

  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze
  LAYOUT_TYPE = ['Simple', 'Stylish']
  has_many :invoices , dependent: :destroy
  has_one_attached :signature_image

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :phone, length: { is: 10}

  def restore_id!
    self.update(deleted_at: nil)
  end

  def name=(value)
    super(value.to_s.titleize)
  end

end
