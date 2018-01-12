class StockItemGroup < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :allocation

  after_initialize do
    self.quantity ||= 0
  end

  validates :stock_item, :allocation, :quantity, :unit_value, presence: true
  validates :quantity, numericality: {greater_than: 0, only_integer: true}
  validates :unit_value, numericality: {greater_than: 0}
end
