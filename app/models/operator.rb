class Operator < ActiveRecord::Base
    #attr_accessible :name, :email, :canAlocate, :canBuy

    validates :name, :email, :canAlocate, :canBuy, :isAdmin, presence: true
    validates :email, uniqueness: true

    has_many :allocations, through: :allocations_items
    #validates_associated :allocations

    has_many :acquisitions
    #validates_associated :acquisitions

    has_secure_password
end
