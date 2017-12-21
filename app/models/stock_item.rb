class StockItem < ActiveRecord::Base
    validates :short_description, presence: true, length: {maximum: 30}

    def to_s
        short_description
    end
end
