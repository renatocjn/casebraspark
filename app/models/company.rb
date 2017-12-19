class Company < ActiveRecord::Base
    has_many :acquisitions

    validates :name, :cnpj, presence: {message: "Esta informação deve ser informada"}
    validates :cnpj, format: {with: /[0-9]{2}\.?[0-9]{3}\.?[0-9]{3}\/?[0-9]{4}\-?[0-9]{2}/, message: "O CNPJ deve seguir o formato 00.000.000/0000-00"}

    def park_value
        sum = 0
        company.acquisitions.each do |a|
            sum += a.totalValue
        end
        return sum
    end
end
