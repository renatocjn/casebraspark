class Acquisition < ActiveRecord::Base
    attachment :invoice, content_type: ["image/jpeg", "image/png", "image/gif", "application/pdf"]

    belongs_to :supplier
    belongs_to :company

    has_one :destination, through: :allocation
    belongs_to :allocation, inverse_of: :acquisition, dependent: :destroy
    accepts_nested_attributes_for :allocation

    has_many :items, through: :allocation
    has_many :stock_item_groups, through: :allocation

    before_validation do
        self.allocation.operator ||= self.operator
    end

    validates :invoice_number, :supplier, :company, :invoice, presence: true
    validates :invoice_number, uniqueness: true

    def total_plated_items_value
        items.reduce(0) {|acc, i| acc += i.value}
    end

    def total_stock_items_value
        stock_item_groups.reduce(0) {|acc, g| acc += g.quantity*g.unit_value}
    end

    def totalValue
        total_plated_items_value + total_stock_items_value
    end

    delegate :count_items, :date, :reason, :type_count, :operator, to: :allocation

    # after_rollback do
    #     logger.debug "*********************************** AFTER_ROLLBACK ***********************************"
    #     logger.debug "acquisition"
    #     errors.full_messages.each {|m| logger.debug m}

    #     logger.debug "allocation #{allocation.nil?}"
    #     allocation.errors.full_messages.each {|m| logger.debug m}

    #     logger.debug "items"
    #     items.each{ |i| i.errors.full_messages.each {|m| logger.debug m} }

    #     logger.debug "stock_item_groups"
    #     stock_item_groups.each {|g| g.errors.full_messages.each {|m| logger.debug m} }
    #     logger.debug "**************************************************************************************"
    # end
end
