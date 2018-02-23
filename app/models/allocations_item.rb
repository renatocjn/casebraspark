class AllocationsItem < ActiveRecord::Base
    belongs_to :allocation, inverse_of: :allocations_items
    belongs_to :item, inverse_of: :allocations_items

    def allocation_is_acquisition
        allocation.is_acquisition
    end

    after_create do
        item.update placement: allocation.destination if allocation.is_acquisition or allocation == item.last_allocation
    end

    before_destroy unless: :allocation_is_acquisition do
        if allocation == item.last_allocation
            item.update placement: item.second_to_last_allocation.destination
        else
            allocation.errors.add :base, "Não pode ser destruída pois faz parte do histórico de seus items"
            false
        end
    end

    after_destroy do
        item.destroy if allocation.is_acquisition
    end

    after_commit on: :destroy do
        allocation.destroy if allocation.empty? and not allocation.frozen?
    end
end
