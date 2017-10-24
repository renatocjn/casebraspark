class Allocation < ActiveRecord::Base
    #attr_accessible :created_at, :reason

    belongs_to :operator
    belongs_to :placement
    belongs_to :acquisition
    validates_associated :acquisition, uniqueness: true, allow_nil: true
    validates :placement, :reason, presence: true

    has_many :allocations_items
    has_many :items, through: :allocations_items
    accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
    #validates_associated :items
end
