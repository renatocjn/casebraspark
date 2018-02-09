
class Allocation < ActiveRecord::Base
    #FIXME figure it out why allocations are not being destroyed

    belongs_to :operator, inverse_of: :allocations
    belongs_to :origin, class_name: "Placement", inverse_of: :allocations
    belongs_to :destination, class_name: "Placement", inverse_of: :allocations
    belongs_to :acquisition, inverse_of: :allocation

    has_many :allocations_items, dependent: :destroy, inverse_of: :allocation
    accepts_nested_attributes_for :allocations_items, allow_destroy: true

    has_many :items, through: :allocations_items, inverse_of: :allocations, validate: true
    accepts_nested_attributes_for :items, allow_destroy: true

    has_many :stock_item_groups, dependent: :destroy, inverse_of: :allocation, validate: true
    has_many :stock_items, through: :stock_item_groups, inverse_of: :allocations
    accepts_nested_attributes_for :stock_item_groups, allow_destroy: true

    validates :reason, :destination, :operator, :date, presence: true
    validates :origin, presence: true, unless: :is_acquisition
    validate :check_presence_of_items
    validate :check_origin_items, unless: :is_acquisition
    validate :check_uniqueness_of_stock_item_id_on_stock_item_groups, on: :create #needed because of nested forms
    validate :check_if_destination_and_origin_are_different

    #validates_associated :items, :stock_item_groups

    def is_acquisition
        not acquisition.nil?
    end

    after_initialize do
        self.date ||= Date.today
    end

    def Allocation::convert_item_attributes_plates_to_join_table_attributes(allocation_attributes)
        new_allocation_attributes = allocation_attributes.deep_dup
        if new_allocation_attributes.include? :items_attributes
            all_items_found = true
            items_attributes = new_allocation_attributes.delete :items_attributes
            ai_attributes = Hash.new
            items_attributes.each do |item_key, item_attributes|
                if item_attributes[:id].blank?
                    item = Item.where(placement_id: item_attributes[:origin_id]).select(:id).find_by_plate(item_attributes[:plate])
                else
                    item = Item.where(placement_id: item_attributes[:origin_id]).select(:id).find(item_attributes[:id])
                end

                if item.nil?
                    all_items_found = false
                    break
                else
                    ai_attributes[item_key] = {item_id: item.id, _destroy: item_attributes[:_destroy]}
                end
            end

            if all_items_found
                new_allocation_attributes[:allocations_items_attributes] = ai_attributes
            else
                new_allocation_attributes[:items_attributes] = items_attributes
            end
        end
        #FIXME not returning the altered array
        return new_allocation_attributes
    end

    def Allocation::create_from_plates alloc_attributes
        new_allocation_attributes = Allocation::convert_item_attributes_plates_to_join_table_attributes alloc_attributes
        #FIXME fix problem with stock_item_group quantity validations
        new_allocation = Allocation.new new_allocation_attributes
        logger.debug new_allocation_attributes
        logger.debug new_allocation
        logger.debug new_allocation.items
        logger.debug new_allocation.stock_item_groups
        if new_allocation.valid?
            logger.debug "Valid"
            return new_allocation
        else
            logger.debug "Invalid"
            new_allocation.errors.full_messages.each {|m| logger.debug m}
            return Allocation.new alloc_attributes
        end
    end

    def update_from_plates alloc_attributes
        #TODO make update show validation errors
        new_allocation_attributes = Allocation::convert_item_attributes_plates_to_join_table_attributes alloc_attributes

        self.transaction do
            self.allocations_items.destroy_all
            self.update new_allocation_attributes
        end
    end

    def check_uniqueness_of_stock_item_id_on_stock_item_groups
        stock_item_ids = stock_item_groups.collect {|g| g.stock_item_id}
        errors.add :base, "Existem items sem plaqueta duplicados" if stock_item_ids.uniq.length != stock_item_ids.length and stock_item_ids.length > 1
    end

    def check_presence_of_items
        errors.add :base, "Algo deve ser registrado nesta movimentação" unless items.any? or stock_item_groups.any? or allocations_items.any?
    end

    def check_origin_items
        #FIXME add_error_to_all_groups on nil origin mot working
        add_error_to_all = origin.nil? ? true : false

        items.each do |i|
            i.errors.add :plate, "Esta plaqueta não foi encontrada no local de origem" if add_error_to_all or Item.where(placement: origin_id).find_by_plate(i.plate).nil?
        end

        stock_item_groups.each do |group|
            stock_count = StockItemCount.find_by(stock_item: group.stock_item, placement: origin)
            if stock_count.nil? or add_error_to_all
                group.errors.add :stock_item_id, "Este item não foi encontrado no local de origem"
            else
                group.errors.add :quantity, "O local de origem não tem a quantidade de items necessária" unless stock_count.count >= group.quantity
            end
        end
    end

    def check_if_destination_and_origin_are_different
        if origin == destination
            self.errors.add :origin, "Deve ser diferente do destino"
            self.errors.add :destination, "Deve ser diferente da origem"
        end
    end

    after_update do
        self.stock_item_groups.each do |group|
            unless is_acquisition
                stock_count = StockItemCount.where(stock_item: group.stock_item_id_was, placement_id: origin_id_was).first_or_initialize
                stock_count.count += group.quantity_was.nil? ? 0 : group.quantity_was
                stock_count.save

                stock_count = StockItemCount.where(stock_item: group.stock_item, placement_id: origin_id).first
                stock_count.count -= group.quantity
                if stock_count.count > 0
                    stock_count.save
                else
                    stock_count.destroy
                end
            end

            stock_count = StockItemCount.where(stock_item: group.stock_item_id_was, placement_id: destination_id_was).first_or_initialize
            stock_count.count -= group.quantity_was.nil? ? 0 : group.quantity_was
            if stock_count.count > 0
                stock_count.save
            else
                stock_count.destroy
            end

            stock_count = destination.stock_item_counts.where(stock_item: group.stock_item).first_or_initialize
            stock_count.count += group.quantity
            stock_count.save
        end

        self.items.each { |i| i.update placement_id: destination if destination_id_changed? and self==i.last_allocation}
    end



    after_create do
        self.stock_item_groups.each do |group|
            unless is_acquisition
                stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
                stock_count.count -= group.quantity
                if stock_count.count == 0
                    stock_count.destroy!
                else
                    stock_count.save!
                end
            end

            stock_count = destination.stock_item_counts.where(stock_item: group.stock_item).first_or_initialize
            stock_count.count += group.quantity
            stock_count.save!
        end

        self.items.update_all placement_id: destination
    end

    def get_origin
        is_acquisition ? acquisition.supplier : origin
    end

    def count_items
        stock_item_groups.reduce(0) {|acc, g| acc += g.quantity} + items.count
    end

    def type_count
        self.items.select(:id, :parkable_item_type).group(:parkable_item_type).count(:id).each_with_object(Hash.new) do |i, hash|
            hash[Item::TYPES_TRANSLATIONS[i[0]]] = i[1]
        end
    end

    after_destroy do
        self.items.each do |i|
            i.update placement_id: i.last_allocation.placement
        end
    end

    #after_rollback do
    #    logger.debug "******AFTER ROLLBACK******"
    #    errors.full_messages.each {|e| logger.debug e }
    #    allocations_items.each { |i| logger.debug i.inspect; i.errors.full_messages.each {|e| logger.debug e } } if self.errors[:allocations_items].any?
    #    items.each { |i| logger.debug i.inspect; i.errors.full_messages.each {|e| logger.debug e } } if self.errors[:items].any?
    #    stock_item_groups.each { |g| logger.debug g.inspect;  g.errors.full_messages.each {|e| logger.debug e } } if self.errors[:stock_item_groups].any?
    #    logger.debug "**************************"
    #end
end
