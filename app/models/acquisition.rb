class Acquisition < ActiveRecord::Base
    attachment :invoice, content_type: ["image/jpeg", "image/png", "image/gif", "application/pdf"]

    belongs_to :operator
    belongs_to :supplier
    belongs_to :company

    has_one :allocation, dependent: :destroy, inverse_of: :acquisition
    has_one :destination, through: :allocation
    has_many :items, through: :allocation
    has_many :stock_item_groups, through: :allocation

    accepts_nested_attributes_for :allocation, reject_if: :all_blank
    validates_associated :allocation

    before_validation do
        self.allocation.operator = self.operator
    end

    validates :invoice_number, :supplier, :allocation, :company, :operator, :invoice, presence: true
    validates :invoice_number, uniqueness: true

    def totalValue
        items.pluck(:value).sum() + stock_item_groups.reduce(0) {|acc, g| acc += g.quantity*g.unit_value}
    end

    delegate :count_items, :date, :reason, :type_count, to: :allocation

    after_rollback do
        errors.full_messages.each {|m| logger.debug m}
        errors.full_messages_for(:allocation).each {|m| logger.debug m}
        errors.full_messages_for(:items).each {|m| logger.debug m}
        errors.full_messages_for(:stock_item_groups).each {|m| logger.debug m}
    end


end
