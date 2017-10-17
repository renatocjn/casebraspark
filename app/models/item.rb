class Item < ActiveRecord::Base
    #attr_accessible :shortDescription, :longDescription, :value

    has_many :allocations_items
    has_many :allocations, through: :allocations_items
    has_many :placements, through: :allocations

    validates :shortDescription, :longDescription, :value, presence: true
    validates :value, :numericality => { :greater_than_or_equal_to => 0 }
end
