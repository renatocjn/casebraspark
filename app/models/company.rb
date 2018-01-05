class Company < ActiveRecord::Base
    has_many :acquisitions
    has_many :items, through: :acquisitions
    has_many :stock_item_groups, through: :acquisitions

    validates :name, :cnpj, presence: true
    validates :cnpj, format: {with: /[0-9]{2}\.?[0-9]{3}\.?[0-9]{3}\/?[0-9]{4}\-?[0-9]{2}/, message: "O CNPJ deve seguir o formato 00.000.000/0000-00"}

    def park_value
        acquisitions.reduce(0) {|acc, acquisition| acc += acquisition.totalValue}
    end
end
