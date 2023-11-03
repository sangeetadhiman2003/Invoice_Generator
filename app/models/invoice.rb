class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :items, dependent: :destroy
  has_one_attached :logo_image
  accepts_nested_attributes_for :items , allow_destroy: true

  validates :invoice_no, presence: true
  validates :invoice_date, presence: true
  validates :notes, presence: true
  validates :user_id, presence: true
  validates :terms_and_condition, presence: true

  def calculate_total(item)
    item.quantity * item.product&.rate
  end

  def calculate_total_tax
    items.sum { |item| item.product&.tax_value }
  end

  def calculate_total_gst
    items.sum { |item| ((item.product&.rate)*(item.product&.gst))/100 }
  end


  def calculate_sub_total
    total_gst = calculate_total_gst
    sub_total = items.sum { |item| + item.product&.rate }
    ans = sub_total + total_gst
  end

  def calculate_grand_total
    total_tax = calculate_total_tax
    total_gst = calculate_total_gst
    total_item_rates = items.sum { |item| item.product&.rate }
    grand_total = total_item_rates + total_tax + total_gst
  end

  def calculate_discount
    grand_total = calculate_grand_total
    discounted_amount = 0
    if grand_total >= 50000
      discount_percentage = 25 # 25% discount
      discount = (grand_total * discount_percentage) / 100

      # Calculate the final discounted amount
      discounted_amount = grand_total - discount
    else
      discounted_amount = 0.0
    end
  end

  def calculate_amount_paid
    items.sum { |item| item&.amountPaid }
  end

  def calculate_due
    grand_total = calculate_grand_total
    total_amountPaid = calculate_amount_paid

    if  total_amountPaid >=  grand_total
      due_balance = 0
    else
      due_balance = grand_total - total_amountPaid
    end


  end


end
