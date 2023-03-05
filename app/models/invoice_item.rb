class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def applied_discount
    bulk_discounts.
    joins(:invoice_items)
    .select("bulk_discounts.id as discount_id")
    .where("bulk_discounts.quantity_threshold <= invoice_items.quantity and #{self.id} = invoice_items.id")
    .order("bulk_discounts.percentage_discount desc")
    .first
  end

end
