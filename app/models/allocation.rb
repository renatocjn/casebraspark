class Allocation < ActiveRecord::Base

    belongs_to :operator, inverse_of: :allocations
    belongs_to :origin, class_name: "Placement", inverse_of: :allocations
    belongs_to :destination, class_name: "Placement", inverse_of: :allocations
    belongs_to :acquisition, inverse_of: :allocation

    has_many :allocations_items, dependent: :destroy, inverse_of: :allocation
    accepts_nested_attributes_for :allocations_items, allow_destroy: true

    has_many :items, through: :allocations_items, dependent: :destroy, inverse_of: :allocations
    accepts_nested_attributes_for :items, allow_destroy: true

    has_many :stock_item_groups, dependent: :destroy, inverse_of: :allocation
    has_many :stock_items, through: :stock_item_groups, inverse_of: :allocations
    accepts_nested_attributes_for :stock_item_groups, allow_destroy: true

    def is_acquisition
        not acquisition.nil?
    end

    after_initialize do
        self.date ||= Date.today
    end

    def build_allocations_items(allocations_item_attributes)
        logger.debug "TESTANDO " + allocations_item_attributes.inspect
    end

    #before_validation do
    #    if self.date.is_a? String
    #        begin
    #            self.date = Date.parse(self.date)
    #        rescue ArgumentError => err
    #            self.errors.add :date, "Formato de data inválido"
    #        end
    #    end
    #end

    validates :reason, :destination, :operator, :date, presence: true
    validates :origin, presence: true, unless: :is_acquisition
    validate :check_presence_of_items
    validate :check_origin_items, unless: :is_acquisition

    #validates_associated :items
    validates_associated :stock_item_groups

    # def Allocation::build_from_plates(allocation_attributes, plates)
    #     self.transaction do
    #         newAllocation = Allocation.new allocation_attributes
    #         i=0
    #         allocations_items_attributes = {}
    #         plates.each do |p|
    #             item = newAllocation.origin.items.where(plate: p).first
    #             if item.nil?
    #                 raise "Plaqueta #{p} não encontrada"
    #             else
    #                 allocations_items_attributes[i+=1] = {:item_id => item.id}
    #             end
    #         end
    #         newAllocation.allocations_items_attributes = allocations_items_attributes
    #         newAllocation.save
    #         return newAllocation
    #     end
    # end

    def check_presence_of_items
        errors.add :base, "Algo deve ser registrado nesta movimentação" unless items.any? or stock_item_groups.any?
    end

    def check_origin_items
        items.each { |i| i.errors.add :plate, "Esta plaqueta não foi encontrada no local de origem" unless self.origin.items.find_by_plate i.plate }
        #logger.debug "Items válidos? #{items.all? { |i| i.valid? }}"
        #items.each {|i| i.errors.messages.each {|m| logger.debug m}}

        self.stock_item_groups.each do |group|
            stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
            if stock_count.nil?
                group.errors.add :stock_item, "Este item não foi encontrado no local de origem"
            else
                group.errors.add :quantity, "O local de origem não tem a quantidade de items necessária" unless stock_count.count >= group.quantity
            end
        end

        #logger.debug "Grupos válidos? #{stock_item_groups.all? {|g| g.valid?}}"
        #stock_item_groups.each {|g| g.errors.messages.each {|m| logger.debug m}}
    end

    before_update do
        self.stock_item_groups.each do |group|
            unless is_acquisition
                stock_count = StockItemCount.where(stock_item: group.stock_item_id_was, placement_id: origin_id_was).first_or_initialize
                stock_count.count += group.quantity_was ? group.quantity_was : 0
                stock_count.save

                stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
                stock_count.count -= group.quantity
                if stock_count.count > 0
                    stock_count.save
                else
                    stock_count.destroy
                end
            end

            stock_count = StockItemCount.where(stock_item: group.stock_item_id_was, placement_id: destination_id_was).first
            stock_count.count -= group.quantity_was ? group.quantity_was : 0
            if stock_count.count > 0
                stock_count.save
            else
                stock_count.destroy
            end

            stock_count = destination.stock_item_counts.where(stock_item: group.stock_item).first_or_initialize
            stock_count.count += group.quantity
            stock_count.save
        end
    end

    after_save do
        items.each {|i| i.update placement: destination } if destination_id_changed?
    end

    after_create do
        self.stock_item_groups.each do |group|
            #unless destination.stock_item_counts.where(stock_item: group.stock_item).any?
            #    destination.stock_item_counts.create stock_item: group.stock_item
            #end

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

    after_rollback do
        logger.debug "******AFTER ROLLBACK******"
        errors.full_messages.each {|e| logger.debug e }
        logger.debug "AllocationsItems " + allocations_items.inspect
        allocations_items.each { |i| i.errors.full_messages.each {|e| logger.debug e } }
        logger.debug "Items " + items.inspect
        items.each { |i| i.errors.full_messages.each {|e| logger.debug e } }
        logger.debug "StockitemGroups " + stock_item_groups.inspect
        stock_item_groups.each { |g| g.errors.full_messages.each {|e| logger.debug e } }
        logger.debug "**************************"
    end
end
