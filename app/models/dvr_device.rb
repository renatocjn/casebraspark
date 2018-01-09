class DvrDevice < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    CH_NUMBERS = [4, 8, 16, 32]

    validates :number_of_channels, presence: true, inclusion: {in: CH_NUMBERS}
end
