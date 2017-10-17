class Placement < ActiveRecord::Base
    #attr_accessible :description

    validates :description, presence: :true

    has_many :allocations
    has_many :items, through: :allocations
end
