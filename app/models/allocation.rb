class Allocation < ActiveRecord::Base

    belongs_to :operator
    belongs_to :origin, class_name: "Placement"
    belongs_to :destination, class_name: "Placement"
    belongs_to :acquisition

    has_many :allocations_items
    has_many :items, through: :allocations_items
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

    has_many :stock_item_groups
    has_many :stock_items, through: :stock_item_groups
    accepts_nested_attributes_for :stock_item_groups, reject_if: :all_blank, allow_destroy: true

    def is_acquisition
        origin.nil?
    end

    validates :reason, :destination, :operator, presence: true
    validates :origin, presence: true, unless: :is_acquisition
    validate :check_presence_of_items
    validate :check_origin_items, unless: :is_acquisition
    validates_associated :items
    validates_associated :stock_item_groups

    def check_presence_of_items
        unless self.items.any? or self.stock_item_groups.any?
            errors.add_to_base "Algum item deve ser registrado nesta movimentação"
        end
    end

    def check_origin_items
        items.each do |i|
            unless self.origin.items.exists? i.id
                i.errors.add :plate, "Esta plaqueta não foi encontrada no local de origem"
            end
            logger.debug i.errors.inspect
        end

        self.stock_item_groups.each do |group|
            stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
            if stock_count.nil?
                stock_count.errors.add :id, "Este item não foi encontrado no local de origem"
            else
                unless stock_count.count >= group.quantity
                    stock_count.errors.add :id, "O local de origem não tem a quantidade de items necessária"
                end
            end
        end
    end

    after_save on: :create do
        self.stock_item_groups.each do |group|
            unless destination.stock_item_counts.where(stock_item: group.stock_item).any?
                destination.stock_item_counts.create stock_item: group.stock_item
            end

            unless self.is_acquisition
                stock_count = origin.stock_item_counts.where(stock_item: group.stock_item).first
                stock_count.count -= group.quantity
                if stock_count.count == 0
                    stock_count.destroy!
                else
                    stock_count.save!
                end
            end

            stock_count = destination.stock_item_counts.where(stock_item: group.stock_item).first
            stock_count.count += group.quantity
            stock_count.save!
        end
    end

    after_save on: :update do
        items.each {|i| i.update placement: destination } if destination_id_changed?
    end

    def get_origin
        if is_acquisition
            acquisition.supplier
        else
            origin
        end
    end

    def count_items
        stock_item_groups.reduce(0) {|acc, g| acc += g.quantity} + items.count
    end

    after_rollback do
        errors.full_messages.each do |e|
            logger.debug e
        end
        stock_item_groups.each do |g|
            g.errors.full_messages.each do |e|
                logger.debug e
            end
        end
    end
end
