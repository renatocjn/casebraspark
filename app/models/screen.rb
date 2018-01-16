class Screen < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy
    delegate :plate, :brand, :model, :serial, :value, to: :item

    validates :inches,
        presence: true,
        numericality: {greater_than: 0}
end
