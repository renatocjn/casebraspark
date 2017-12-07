class Item < ActiveRecord::Base
    #attr_accessible :shortDescription, :longDescription, :value

    has_many :allocations_items
    has_many :allocations, through: :allocations_items
    has_many :placements, through: :allocations

    validates :dischargeDescription, presence: { message: "Um motivo deve ser fornecido" }, if: :isDischarged

    validates :plate, :model, :serial, :brand, :item_type, :value, presence: { message: "Informação obrigatória" }
    validates :plate, uniqueness: { message: "Esta plaqueta já foi registrada" }
    validates :value, :numericality => { :greater_than_or_equal_to => 0, message: "Deve ser fornecido um valor numérico positivo" }

    def to_s
        r = ""
        r << item_type.name << " " << brand << " " << model
        return r
    end

    def tiposDeItems
        ["Monitor" => Monitor, "Computador" => Computador, "Impressora" => Impressora]
    end

    scope :lions, -> { where(race: 'Lion') }
    scope :meerkats, -> { where(race: 'Meerkat') }
    scope :wild_boars, -> { where(race: 'WildBoar') }
end

class MonitorTMP < Item
    validates :inches, presence: { message: "O tamanho do monitor deve ser especificado" }
end

class Computador < Item
    validates :processor, :memory, :harddrive, presence: { message: "Informação obrigatória" }
end

class Impressora < Item
end
