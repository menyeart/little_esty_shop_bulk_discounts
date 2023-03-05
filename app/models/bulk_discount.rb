class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount, 
                        :quantity_threshold,
                        :merchant_id

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

end