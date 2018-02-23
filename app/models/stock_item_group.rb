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

  def check_stock_item_and_quantity_on_origin
    stock_count = StockItemCount.find_by(stock_item: self.stock_item, placement: allocation.origin)
    if allocation.origin.nil? or stock_count.nil?
        errors.add :stock_item_id, "Este item não foi encontrado no local de origem"
    else
        errors.add :quantity, "O local de origem não tem a quantidade de items necessária" unless stock_count.count >= self.quantity
    end
  end
  validate :check_stock_item_and_quantity_on_origin, on: :create, unless: :allocation_is_acquisition?

  after_create do
    unless allocation.is_acquisition
      stock_count = StockItemCount.where(placement: allocation.origin, stock_item: self.stock_item).first
      stock_count.count -= self.quantity
      if stock_count.count == 0
          stock_count.destroy!
      else
          stock_count.save!
      end
    end

    stock_count = StockItemCount.where(placement: allocation.destination, stock_item: self.stock_item).first_or_initialize
    stock_count.count += self.quantity
    stock_count.save!
  end

  after_destroy do
    unless allocation.is_acquisition
      stock_count = StockItemCount.where(stock_item: self.stock_item, placement: allocation.origin).first_or_initialize
      stock_count.count += self.quantity
      stock_count.save
    end

    stock_count = StockItemCount.where(stock_item: self.stock_item, placement: allocation.destination).first
    unless stock_count.nil?
      stock_count.count -= self.quantity
      if stock_count.count > 0
          stock_count.save
      else
          stock_count.destroy
      end
    end

    allocation.destroy if allocation.empty?
  end

  after_touch do
    unless allocation.is_acquisition
      stock_count = StockItemCount.where(stock_item: self.stock_item_id_was, placement_id: allocation.origin_id_was).first_or_initialize
      stock_count.count += self.quantity_was.nil? ? 0 : self.quantity_was
      stock_count.save

      stock_count = StockItemCount.where(stock_item: self.stock_item, placement: allocation.origin).first
      stock_count.count -= self.quantity
      if stock_count.count > 0
          stock_count.save
      else
          stock_count.destroy
      end
    end

    stock_count = StockItemCount.where(stock_item: self.stock_item_id_was, placement_id: allocation.destination_id_was).first
    unless stock_count.nil?
      stock_count.count -= self.quantity_was.nil? ? 0 : self.quantity_was
      if stock_count.count > 0
          stock_count.save
      else
          stock_count.destroy
      end
    end

    stock_count = StockItemCount.where(stock_item: self.stock_item, placement_id: allocation.destination_id).first_or_initialize
    stock_count.count += self.quantity
    stock_count.save
  end

  after_commit on: :destroy do
    allocation.destroy if allocation.empty? and not allocation.frozen?
  end
end
