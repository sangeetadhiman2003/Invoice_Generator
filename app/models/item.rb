class Item < ApplicationRecord

  belongs_to :invoice
  belongs_to :product

  ITEM_TYPES = ['Laptop', 'Mobile', 'Watch' ]

  def calculate_total
    subtotal = product.rate
    total_tax = product.tax_value + (product.rate * (product.gst)/100)
    subtotal + total_tax
  end
end
