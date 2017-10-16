class Acquisition < ActiveRecord::Base
    #attr_accessible :supplier, :reason, :created_at
    validates :supplier, :reason, presence: true

    belongs_to :operator
    #validates_associated :operator

    belongs_to :allocation
    #validates_associated :allocation

    has_many :items
    #validates_associated :items

    accepts_nested_attributes_for :allocation, :reject_if => :all_blank
    validates :allocation, uniqueness: true

    def totalValue
        return items.pick(:value).sum()
    end
end
