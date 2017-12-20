class StockItemsType < ActiveRecord::Base
    has_many :stock_items

    validates :description, presence: true

    def to_s
        description
    end
end
