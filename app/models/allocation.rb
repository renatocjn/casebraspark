class Allocation < ActiveRecord::Base

    belongs_to :operator
    belongs_to :placement
    belongs_to :acquisition

    has_many :allocations_items
    has_many :items, through: :allocations_items
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

    validates :operator, :placement, :acquisition, :reason, presence: true
    validates_associated :items
end
