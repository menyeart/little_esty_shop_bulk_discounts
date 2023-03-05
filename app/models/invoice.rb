class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def amount_discounted
    invoice_items
    .joins(:bulk_discounts)
    .select("MAX((invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage_discount) as total")
    .where("bulk_discounts.quantity_threshold <= invoice_items.quantity")
    .group("invoice_items.id")
    .sum(&:total)
  end

  # def invoice_items_with_discounts
  #   invoice_items
  #   .joins(:bulk_discounts)
  #   .select("invoice_items.*, bulk_discounts.id as discount_id")
  #   .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
  #   .order("bulk_discounts.percentage_discount desc")
  #   .limit(1)
  # end
end
