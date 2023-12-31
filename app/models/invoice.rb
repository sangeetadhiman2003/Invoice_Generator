class Invoice < ApplicationRecord
  # TODO: naming
  before_create :set_invoicenumber

  belongs_to :user
  belongs_to :client
  has_many :items, dependent: :destroy
  has_many :services, dependent: :destroy
  has_one_attached :logo_image

  accepts_nested_attributes_for :items , allow_destroy: true
  accepts_nested_attributes_for :services , allow_destroy: true

  validates :invoice_no, :invoice_date, :user_id,  presence: true
  # validates :terms_and_condition, presence: true
  # validates :notes, presence: true

  def calculate_total(item)
    item&.quantity * item.product&.rate
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

  def self.next_invoice_number
    current_year = Date.today.year.to_s
    last_invoice_number = Invoice.where("invoice_no LIKE ?", "invoice/#{current_year}/%").maximum(:invoice_no)

    if last_invoice_number
      last_number = last_invoice_number.split('/').last.to_i
      next_number = last_number + 1
    else
      next_number = 1
    end

    "invoice/#{current_year}/" + "%03d" % next_number
  end

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at]))
  end

  def sub_total_service(service)
    service&.hour * service&.amount
  end

  def calculate_tax(sub_total)
    if sub_total > 20000
      return 200
    else
      return 100
    end
  end

  def calculate_total_amount(sub_total,tax)
    return sub_total + tax
  end

  private

  def set_invoicenumber
    self.invoice_no = Invoice.next_invoice_number
  end

end
