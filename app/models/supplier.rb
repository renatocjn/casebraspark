class Supplier < ActiveRecord::Base
    has_many :acquisitions
    has_many :items, through: :acquisitions
    has_many :stock_item_groups, through: :acquisitions
    has_many :stock_items, through: :stock_item_groups

    validates :name, :phones, presence: true
    validates :email, format: {with: /\S+@\S+.\S/, message: "E-mail inválido"}, allow_nil: true

    def to_s
        name
    end

    def get_buyable_items
        items.select(:parkable_item_type).distinct.map {|i| i.type_pt_BR} +
            stock_items.select(:short_description).distinct.pluck(:short_description)
    end
end
