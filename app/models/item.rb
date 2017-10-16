class Item < ActiveRecord::Base
    #attr_accessible :shortDescription, :longDescription, :value

    has_many :allocations, through: :allocations_items

    validates :shortDescription, :longDescription, :value, presence: true
    validates :value, numericality: true
end
