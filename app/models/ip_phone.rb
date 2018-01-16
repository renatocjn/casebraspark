class IpPhone < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy
    delegate :plate, :brand, :model, :serial, :value, to: :item
end
