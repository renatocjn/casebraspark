class NetworkDevice < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy
    delegate :plate, :brand, :model, :serial, :value, to: :item

    FUNCTIONS = %w(Roteador Switch Modem)

    validates :function, presence: true, inclusion: {in: FUNCTIONS}
end
