class Acquisition < ActiveRecord::Base

    belongs_to :operator
    belongs_to :supplier
    belongs_to :company
    has_one :allocation
    has_one :placement, through: :allocation

    has_many :items, through: :allocation
    has_many :stock_items

    accepts_nested_attributes_for :allocation, reject_if: :all_blank

    validates :supplier, :allocation, :company, :invoice_number, :operator, presence: true
    validate :check_items_presence
    validates_associated :allocation

    def totalValue
        return items.pluck(:value).sum()
    end

    def check_items_presence
        unless [self.items, self.stock_items].any? {|l| l.any?}
            self.errors.add "Adicione pelo menos um item"
        end
    end
end
