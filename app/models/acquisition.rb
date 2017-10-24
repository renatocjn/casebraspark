class Acquisition < ActiveRecord::Base
    #attr_accessible :supplier, :reason, :created_at
    validates :supplier, :reason, :allocation, presence: true

    belongs_to :operator
    #validates_associated :operator

    has_one :allocation
    #validates_associated :allocation

    has_one :placement, through: :allocation

    has_many :items, through: :allocation
    #validates_associated :items

    accepts_nested_attributes_for :allocation, :reject_if => :all_blank
    #validates :allocation, uniqueness: true

    def totalValue
        return items.pluck(:value).sum()
    end
end
