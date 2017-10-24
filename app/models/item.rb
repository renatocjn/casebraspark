class Item < ActiveRecord::Base
    #attr_accessible :shortDescription, :longDescription, :value

    has_many :allocations_items
    has_many :allocations, through: :allocations_items
    has_many :placements, through: :allocations
    belongs_to :item_type

    validates :dischargeDescription, presence: true, if: :isDischarged

    validates :plate, :model, :serial, :brand, :item_type, :value, presence: true
    validates :plate, uniqueness: true
    validates :value, :numericality => { :greater_than_or_equal_to => 0 }

    def to_s
        r = ""
        r << item_type.name << " " << brand << " " << model
        return r
    end
end
