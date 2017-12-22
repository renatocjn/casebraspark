class Computer < ActiveRecord::Base
    has_one :item, as: :parkable_item, dependent: :destroy

    validates :processor, :harddrive, :memory, presence: true
    validate :checar_descritor_de_quantidade_de_bytes

    private
    def checar_descritor_de_quantidade_de_bytes
        {:harddrive => self.harddrive, :memory => self.memory}.each do |key, str|
            unless ['KB', 'MB', 'GB', 'TB'].any? { |word| str.strip.ends_with?(word) }
                errors.add key, "Deve terminar com KB, MB, GB ou TB"
            end
        end
    end
end
