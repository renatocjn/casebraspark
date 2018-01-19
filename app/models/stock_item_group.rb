class StockItemGroup < ActiveRecord::Base
  belongs_to :stock_item, inverse_of: :stock_item_groups
  belongs_to :allocation, inverse_of: :stock_item_groups

  after_initialize do
    self.quantity ||= 0
  end

  validates :stock_item_id, presence: true, uniqueness: {scope: :allocation_id, message: "Já existe um registro para esse item"}
  validates :quantity, presence: true, numericality: {greater_than: 0, only_integer: true}

  def allocation_is_acquisition?
    self.allocation.is_acquisition
  end
  validates :unit_value, presence: true, numericality: {greater_than: 0}, if: :allocation_is_acquisition?
  validates :unit_value, absence: true, unless: :allocation_is_acquisition?
end
