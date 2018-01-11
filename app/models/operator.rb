class Operator < ActiveRecord::Base

    has_many :allocations
    has_many :acquisitions
    has_secure_password

    after_initialize do
        self.isAdmin ||= false
        self.isBlocked ||= false
    end

    validates :name, :email, presence: true
    validates :email, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "E-mail inválido"}, uniqueness: true

    validates :password, confirmation: true, length: {minimum: 8}
    validates :password, format: {with: /[A-Z]/, message: "Sua senha deve conter caracteres maiúsculos"}
    validates :password, format: {with: /[a-z]/, message: "Sua senha deve conter caracteres minúsculos"}
    validates :password, format: {with: /[0-9]/, message: "Sua senha deve conter caracteres numéricos"}

    validates :isAdmin, :isBlocked, inclusion: [true, false]

    def to_s
        name
    end
end
