class Acquisition < ActiveRecord::Base
    belongs_to :operator
    belongs_to :supplier
    belongs_to :company

    has_one :allocation
    has_one :destination, through: :allocation
    has_many :items, through: :allocation
    has_many :stock_item_groups, through: :allocation
    accepts_nested_attributes_for :allocation, reject_if: :all_blank

    before_validation do
        self.allocation.operator = self.operator
    end

    validates :invoice_number, :supplier, :allocation, :operator, presence: true
    validates :invoice_number, uniqueness: true

    def totalValue
        items.pluck(:value).sum()
    end

    delegate :count_items, :reason, to: :allocation

    after_rollback do
        logger.debug self.inspect
        logger.debug self.allocation.inspect
        allocation.items.each { |i| logger.debug i.inspect }
        allocation.stock_item_groups.each { |i| logger.debug i.inspect }
    end
end
