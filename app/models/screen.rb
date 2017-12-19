class Screen < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    validates :inches,
        presence: {message: "O tamanho do monitor deve ser fornecido"},
        numericality: {greater_than: 0, message: "Deve ser um valor numérico positivo"}
end
