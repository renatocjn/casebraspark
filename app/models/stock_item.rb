class StockItem < ActiveRecord::Base
  belongs_to :acquisition
  belongs_to :stock_item_types

  validates :serial_number, :short_description, :acquisition, :stock_item_types, presence: true
  validates :short_description, length: {maximum: 30}
end
