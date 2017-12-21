class Acquisition < ActiveRecord::Base
    belongs_to :operator
    belongs_to :supplier
    belongs_to :company

    has_one :allocation
    has_one :placement, through: :allocation
    has_many :items, through: :allocation
    accepts_nested_attributes_for :allocation, reject_if: :all_blank

    before_validation do
        self.operator ||= Operator.find(session[:user_id])
    end

    validates :invoice_number, :supplier, :allocation, :operator, presence: true

    def totalValue
        items.pluck(:value).sum()
    end

    def reason
        allocation.reason
    end
end
