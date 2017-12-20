class Operator < ActiveRecord::Base
    validates :name, :email, presence: true
    validates :email, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "E-mail inválido"}
    validates :email, uniqueness: { message: "Este email já está em uso" }

    validates :password, length: {minimum: 4, message: "A sua senha deve conter pelo menos 4 caracteres"}
    validates :password, confirmation: true

    #validates :canAlocate, :canBuy, :isAdmin, :isBlocked, inclusion: [true, false]

    has_many :allocations, through: :allocations_items
    has_many :acquisitions

    has_secure_password

    def to_s
        name
    end
end
