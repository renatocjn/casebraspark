class IpCamera < ActiveRecord::Base
    delegate :plate, :brand, :model, :serial, :value, to: :item
end
