
class Allocation < ActiveRecord::Base

    belongs_to :operator, inverse_of: :allocations
    belongs_to :origin, class_name: "Placement", inverse_of: :allocations
    belongs_to :destination, class_name: "Placement", inverse_of: :allocations
    has_one :acquisition, inverse_of: :allocation

    has_many :allocations_items, dependent: :destroy, inverse_of: :allocation
    has_many :items, through: :allocations_items, inverse_of: :allocations, validate: true
    accepts_nested_attributes_for :items, allow_destroy: true

    has_many :stock_item_groups, dependent: :destroy, inverse_of: :allocation, validate: true
    has_many :stock_items, through: :stock_item_groups, inverse_of: :allocations
    accepts_nested_attributes_for :stock_item_groups, allow_destroy: true

    validates :reason, :destination, :operator, :date, presence: true
    validates :origin, presence: true, unless: :is_acquisition
    validate :check_presence_of_items
    validate :block_changes_if_affects_history, on: :update
    validate :check_origin_items, on: :create, unless: :is_acquisition
    validate :check_uniqueness_of_stock_item_id_on_stock_item_groups #needed because of nested forms
    validate :check_if_destination_and_origin_are_different

    def is_acquisition
        not acquisition.nil?
    end

    after_initialize do
        self.date ||= Date.today
    end

    def Allocation::create_from_plates alloc_attributes
        attributes = alloc_attributes.to_h
        items_attributes = attributes.delete "items_attributes"

        unless items_attributes.nil?
            item_plates = items_attributes.collect {|k, h| h["plate"]}
            items = Item.where placement_id: alloc_attributes[:origin_id], plate: item_plates
        end

        if not items_attributes.nil? and item_plates.length == items.count
            new_allocation = Allocation.new attributes
            items.each {|i| new_allocation.items << i}
            return new_allocation
        else
            Allocation.new alloc_attributes
        end
    end

    def update_from_plates alloc_attributes
        attributes = alloc_attributes.to_h
        items_attributes = attributes.delete "items_attributes"

        if items_attributes.nil?
            self.update alloc_attributes
        else
            transaction do
                unless items_attributes.nil?
                    items_attributes.each do |k, item_attributes|
                        item = Item.where(alloc_attributes[:origin_id]).find_by_plate(item_attributes["plate"])
                        if item.nil?
                            self.errors.add :base, "A plaqueta #{item_attributes["plate"]} não foi encontrada no local de origem"
                            raise ActiveRecord::Rollback
                        elsif item_attributes["_destroy"] == "1" or item_attributes["_destroy"] == "true"
                            self.items.destroy item
                        elsif not self.items.include? item
                            self.items << item
                        end
                    end
                end
                self.update attributes
            end
        end
    end

    def block_changes_if_affects_history
        errors.add :destination, "Mudar o destino dessa movimentação invalidaria o histórico" if blocked_due_to_history? and destination_id_changed?
        errors.add :origin, "Mudar a origem dessa movimentação invalidaria o histórico" if origin.present? and blocked_due_to_history? and origin_id_changed?
    end

    def check_uniqueness_of_stock_item_id_on_stock_item_groups
        stock_item_ids = stock_item_groups.collect {|g| g.stock_item_id}
        errors.add :base, "Existem items sem plaqueta duplicados" if stock_item_ids.uniq.length != stock_item_ids.length and stock_item_ids.length > 1
    end

    def check_presence_of_items
        errors.add :base, "Algo deve ser registrado nesta movimentação" if self.empty?
    end

    def check_origin_items
        items.each do |i|
            i.errors.add :plate, "Esta plaqueta não foi encontrada no local de origem" if origin.nil? or Item.where(placement: origin_id).find_by_plate(i.plate).nil?
        end
    end

    def check_if_destination_and_origin_are_different
        if origin == destination
            self.errors.add :origin, "Deve ser diferente do destino"
            self.errors.add :destination, "Deve ser diferente da origem"
        end
    end

    after_update do
        self.stock_item_groups.each(&:touch) if self.destination_id_changed?

        self.items.each do |i|
            i.update placement_id: self.destination_id if self == i.last_allocation
        end
    end

    def blocked_due_to_history?
        self.items.any? {|i| i.last_allocation != self}
    end

    def get_origin
        is_acquisition ? acquisition.supplier : origin
    end

    def count_items
        stock_item_groups.reduce(0) {|acc, g| acc += g.quantity} + items.count
    end

    def empty?
        stock_item_groups.empty? and items.empty?
    end

    def type_count
        items.select(:id, :parkable_item_type).group(:parkable_item_type).count(:id).collect do |i|
            [Item::TYPES_TRANSLATIONS[i[0]], i[1]]
        end.to_h
    end

    def destroy_with_acquisition_if_present
        begin
            if is_acquisition
                acquisition.destroy
            else
                self.destroy
            end
        rescue ActiveRecord::RecordNotDestroyed # Necessary due to what seems to be a rails bug (rails issue #17056 and #18056)
            return false
        end
    end

    # after_rollback do
    #     logger.debug "******AFTER ROLLBACK******"
    #     errors.full_messages.each {|e| logger.debug e }
    #     allocations_items.each { |i| logger.debug i.inspect; i.errors.full_messages.each {|e| logger.debug e } } if self.errors[:allocations_items].any?
    #     items.each { |i| logger.debug i.inspect; i.errors.full_messages.each {|e| logger.debug e } } if self.errors[:items].any?
    #     stock_item_groups.each { |g| logger.debug g.inspect;  g.errors.full_messages.each {|e| logger.debug e } } if self.errors[:stock_item_groups].any?
    #     logger.debug "**************************"
    # end
end
