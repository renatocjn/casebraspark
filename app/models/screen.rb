class Screen < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    validates :inches,
        presence: true,
        numericality: {greater_than: 0}
end
