class Operator < ActiveRecord::Base
    validates :name, :email, presence: true
    validates :email, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "E-mail inválido"}
    validates :email, uniqueness: true

    validates :password, length: {minimum: 4}
    validates :password, confirmation: true

    validates :canAlocate, :canBuy, :isAdmin, :isBlocked, inclusion: [true, false]

    has_many :allocations
    has_many :acquisitions

    has_secure_password

    def to_s
        name
    end
end
