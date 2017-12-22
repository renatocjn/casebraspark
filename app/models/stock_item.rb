class StockItem < ActiveRecord::Base
    has_many :stock_item_counts
    has_many :placements, through: :stock_item_counts

    has_many :stock_item_groups
    has_many :allocations, through: :stock_item_groups
    has_many :acquisitions, through: :allocations

    validates :short_description, presence: true, length: {maximum: 30}

    def to_s
        short_description
    end

    def count
        stock_item_counts.pluck(:count).sum()
    end
end
