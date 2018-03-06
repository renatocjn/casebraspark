class Service < ActiveRecord::Base
    attachment :invoice, content_type: ["image/jpeg", "image/png", "image/gif", "application/pdf"]

    has_many :serviced_items, inverse_of: :service
    has_many :items, through: :serviced_items, inverse_of: :services
    accepts_nested_attributes_for :items, allow_destroy: true

    belongs_to :supplier

    after_initialize do
        self.send_date ||= Date.today
    end

    def recv_date_blank
        self.recv_date.blank?
    end

    def recv_date_after_send_date
        unless self.recv_date > self.send_date
            self.errors.add :send_date, "Deve ser antes da data de recebimento"
            self.errors.add :recv_date, "Deve ser depois da data de envio"
        end
    end

    validates :send_date, :service_type, :supplier, :description, :value, presence: true
    validates :value, numericality: {greater_than: 0}
    validates :invoice, presence: true, unless: :recv_date_blank
    validate :recv_date_after_send_date, unless: :recv_date_blank

    def Service::create_from_plates serv_attributes
        attributes = serv_attributes.to_h
        items_attributes = attributes.delete "items_attributes"

        unless items_attributes.nil?
            item_plates = items_attributes.collect {|k, h| h["plate"]}
            items = Item.where plate: item_plates
        end

        if items_attributes.present? and item_plates.length == items.count
            new_service = Service.new attributes
            items.each {|i| new_service.items << i}
            return new_service
        else
            Service.new serv_attributes
        end
    end

    def update_from_plates serv_attributes
        attributes = serv_attributes.to_h
        items_attributes = attributes.delete "items_attributes"

        if items_attributes.nil?
            self.update serv_attributes
        else
            transaction do
                was_valid = self.update attributes
                items_attributes.each do |k, item_attributes|
                    item = Item.find_by_plate(item_attributes["plate"])
                    if item.nil?
                        self.errors.add :base, "A plaqueta #{item_attributes["plate"]} não foi encontrada"
                        raise ActiveRecord::Rollback
                    elsif was_valid
                        if item_attributes["_destroy"] == "1" or item_attributes["_destroy"] == "true"
                            self.items.destroy item
                        elsif not self.items.include? item
                            self.items << item
                        end
                    end
                end
                was_valid
            end
        end
    end

end
