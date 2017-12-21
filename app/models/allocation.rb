class Allocation < ActiveRecord::Base

    belongs_to :operator
    belongs_to :origin, class_name: "Placement"
    belongs_to :destination, class_name: "Placement"
    belongs_to :acquisition

    has_many :allocations_items
    has_many :items, through: :allocations_items
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

    has_many :stock_item_groups
    has_many :stock_items, through: :stock_item_groups
    accepts_nested_attributes_for :stock_item_groups, reject_if: :all_blank, allow_destroy: true

    def is_acquisition
        not self.acquisition.nil?
    end

    before_validation do
        self.operator ||= Operator.find(session[:user_id])
    end

    validates :reason, :placement, :operator, presence: true
    validates_associated :items
    validates_associated :stock_item_groups
    #validates_associated :acquisition, uniqueness: true, allow_nil: true
    validate :check_origin_stock_quantities, unless: :is_acquisition

    def check_stock_quantities
        self.stock_item_groups.each do |group|
            stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
            if stock_count.nil?
                errors add :stock_item_groups, "Um dos items de estoque não foi encontrado no local de origem"
            end
            unless stock_count.quantity >= group.quantity
                errors.add :stock_item_groups, "O local de origem não tem a quantidade de items necessária"
            end
        end
    end

    after_save on: :create do
        self.stock_item_groups.each do |group|
            if destination.stock_item_counts.where(stock_item: group.stock_item).any?
                destination.build_stock_item_count! stock_item: group.stock_item
            end

            unless self.is_acquisition
                stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
                stock_count.quantity -= group.quantity
                if stock_count.quantity == 0
                    stock_count.destroy!
                else
                    stock_count.save!
                end
            end

            stock_count = destination.stock_item_counts.where(stock_item: group.stock_item).first
            stock_count.quantity += group.quantity
            stock_count.save!
        end
    end
end
