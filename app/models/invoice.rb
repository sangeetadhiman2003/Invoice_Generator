class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :items, dependent: :destroy
  has_one_attached :logo_image
  accepts_nested_attributes_for :items

  validates :invoice_no, presence: true
  validates :invoice_date, presence: true
  validates :notes, presence: true
  validates :user_id, presence: true
  validates :terms_and_condition, presence: true

end
