class Operator < ActiveRecord::Base
    attr_accessor :updating_password

    has_many :allocations
    has_many :acquisitions
    has_secure_password

    after_initialize do
        self.isAdmin ||= false
        self.isBlocked ||= false
        self.updating_password ||= false
    end

    validates :name, :email, presence: true
    validates :email, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "E-mail inválido"}, uniqueness: true

    validates :password, confirmation: true, length: {minimum: 8}, if: :should_validate_password
    validates :password, format: {with: /[A-Z]/, message: "Sua senha deve conter caracteres maiúsculos"}, if: :should_validate_password
    validates :password, format: {with: /[a-z]/, message: "Sua senha deve conter caracteres minúsculos"}, if: :should_validate_password
    validates :password, format: {with: /[0-9]/, message: "Sua senha deve conter caracteres numéricos"}, if: :should_validate_password

    validates :isAdmin, :isBlocked, inclusion: [true, false]

    def to_s
        name
    end

    def should_validate_password
      self.updating_password == "true" or self.new_record?
    end
end
