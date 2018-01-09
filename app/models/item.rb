class Item < ActiveRecord::Base

    has_many :allocations_items
    has_many :allocations, through: :allocations_items
    has_many :placements, through: :allocations, source: :destination
    belongs_to :placement

    belongs_to :parkable_item, polymorphic: true
    accepts_nested_attributes_for :parkable_item#, :reject_if => :all_blank

    delegate :processor, :memory, :harddrive, :inches, to: :parkable_item

    after_initialize do
        self.isDischarged ||= false if self.attributes.key? :isDischarged
    end

    validates :dischargeDescription, presence: true, if: :isDischarged

    validates :plate, :model, :serial, :brand, :value, :parkable_item, presence: true
    #validates :isDischarged, inclusion: {in: [true, false]}
    validates :plate, uniqueness: true
    validates :value, numericality: {:greater_than => 0}

    def description
        "#{type_pt_BR} #{brand} #{model}"
    end

    def to_s
        description
    end

    def build_parkable_item(params) # https://stackoverflow.com/questions/3969025/accepts-nested-attributes-for-with-belongs-to-polymorphic
        self.parkable_item = parkable_item_type.constantize.new(params)
    end

    TYPES_TRANSLATIONS = {
        "Screen" => "Monitor",
        "Printer" => "Impressora",
        "Computer" => "Computador"
    }

    def type_pt_BR
        return Item::TYPES_TRANSLATIONS[parkable_item_type]
    end

    def acquisition
        self.allocations.order(date: :asc).first.acquisition
    end

    before_update do
        self.placement = isDischarged ? nil : self.allocations.order(date: :desc, created_at: :desc).first.destination
    end
end