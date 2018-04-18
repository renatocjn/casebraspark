class Stabilizer < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy
    delegate :plate, :brand, :model, :serial, :value, to: :item

    validates :power, presence: true,
        numericality: {greater_than: 0, only_integer: true}
end
