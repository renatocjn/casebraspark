class IpPhone < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy
end
