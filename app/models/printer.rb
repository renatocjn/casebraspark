class Printer < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    CONNECTIONS = ["Rede", "USB"]
    FUNCTIONS = ["Scanner", "Impressora", "Multifuncional"]
    COLORS = ["Preto e branco", "Colorido"]

    validates :connection, :functions, :paint, presence: true
    validates :connection, inclusion: {in: CONNECTIONS}
    validates :functions, inclusion: {in: FUNCTIONS}
    validates :paint, inclusion: {in: COLORS}
end
