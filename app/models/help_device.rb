class HelpDevice < ActiveRecord::Base
    HelpDevice::DEVICE_TYPES = ["Pad", "Pin Pad", "Scanner", "Webcam", "Biometria"]

    has_one :item, as: :parkable_item, dependent: :destroy
    delegate :plate, :brand, :model, :serial, :value, :placement, to: :item

    validates :kind, presence: true, inclusion: {in: HelpDevice::DEVICE_TYPES}
end
