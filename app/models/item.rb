class Item < ApplicationRecord

ITEM_TYPES = ['Laptop', 'Mobile', 'Watch' ]

  belongs_to :invoice

  validates :name, presence: true
  validates :rate, presence: true
  validates :quantity, presence: true
  validates :hours, presence: true
  validates :gst, presence: true
  validates :tax_value, presence: true
end
