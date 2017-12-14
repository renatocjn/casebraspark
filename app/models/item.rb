class Item < ActiveRecord::Base
    has_many :allocations_items
    has_many :allocations, through: :allocations_items
    has_many :placements, through: :allocations

    belongs_to :parkable_item, polymorphic: true
    accepts_nested_attributes_for :parkable_item, :reject_if => :all_blank

    validates :dischargeDescription, presence: { message: "Um motivo deve ser fornecido" }, if: :isDischarged

    validates :plate, :model, :serial, :brand, :value, presence: { message: "Informação obrigatória" }
    validates :plate, uniqueness: { message: "Esta plaqueta já foi registrada" }
    validates :value, :numericality => { :greater_than_or_equal_to => 0, message: "Deve ser fornecido um valor numérico positivo" }

    def to_s
        r = ""
        r << item_type.name << " " << brand << " " << model
        return r
    end
end