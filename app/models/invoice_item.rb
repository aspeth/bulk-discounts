class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :discounts, through: :item

  enum status: {packaged: 0, pending: 1, shipped: 2}
  validates_presence_of :quantity
  validates_presence_of :status
  validates_presence_of :created_at
  validates_presence_of :updated_at

  def price_to_dollars
    unit_price / 100.to_f
  end

  def has_discount?
    !discounts.where('threshold <= ?', quantity).empty?
  end

  def discount
    discounts.where('threshold <= ?', quantity).order(:percent).limit(1)
  end
end
