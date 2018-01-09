class NetworkDevice < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    FUNCTIONS = %w(Roteador Switch Modem)

    validates :function, presence: true, inclusion: {in: FUNCTIONS}
end
