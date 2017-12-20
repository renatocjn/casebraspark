class Supplier < ActiveRecord::Base
    has_many :acquisitions

    validates :name, :phones, presence: true
    validates :email, format: {with: /\S+@\S+.\S/, message: "E-mail inválido"}, allow_nil: true

    def to_s
        name
    end
end
