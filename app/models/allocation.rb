class Allocation < ActiveRecord::Base
    #attr_accessible :created_at, :reason

    belongs_to :operator

    belongs_to :placement

    belongs_to :acquisition

    has_many :allocations_items
    #accepts_nested_attributes_for :allocations_items, :reject_if => :all_blank, :allow_destroy => true
    #validates_associated :allocations_items

    has_many :items, through: :allocations_items
    accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
    #validates_associated :items
end
