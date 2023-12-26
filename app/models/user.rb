class User < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization

  has_many :clients
  has_many :invoices
  has_many :invoices , dependent: :destroy
  has_one_attached :signature_image

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :phone, length: { is: 10}

  STATE_TYPE = ['MP', 'UP', 'MH', 'AP', 'RJ'].freeze
  LAYOUT_TYPE = ['Simple', 'Stylish']


  def restore_id!
    self.update(deleted_at: nil)
  end

  def name=(value)
    super(value.to_s.titleize)
  end

end
