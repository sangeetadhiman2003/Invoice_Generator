class Item < ApplicationRecord

  ITEM_TYPES = ['Laptop', 'Mobile', 'Watch' ]

  belongs_to :invoice
  belongs_to :product

  def calculate_total
    subtotal = product.rate
    total_tax = product.tax_value + (product.rate * (product.gst)/100)
    subtotal + total_tax
  end
end
