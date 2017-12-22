class StockItemCount < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :placement

  before_validation do
    self.count ||= 0
  end

  validates :stock_item, :placement, :count, presence: true
  validates :count, numericality: {greater_than_or_equal_to: 0, only_integer: true}
end
