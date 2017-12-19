class Acquisition < ActiveRecord::Base
    #attr_accessible :supplier, :reason, :created_at
    validates :supplier, :allocation, presence: true

    belongs_to :operator

    has_one :allocation

    belongs_to :supplier

    belongs_to :company

    has_one :placement, through: :allocation

    has_many :items, through: :allocation

    accepts_nested_attributes_for :allocation, reject_if: :all_blank

    def totalValue
        return items.pluck(:value).sum()
    end
end
