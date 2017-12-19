
class MyValidator < ActiveModel::Validator
  def validate(placement)
    unless [placement.state + placement.city + placement.other].all? {|w| w.blank?}
      placement.errors[:state] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
      placement.errors[:city] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
      placement.errors[:other] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
    end
  end
end

class Placement < ActiveRecord::Base
    #attr_accessible :description

    validates :contact, :address, presence: :true
    validates :state, length: { is: 2, allow_nil: true, allow_blank: true, message: "Deve ser no formato de UF, ex: CE, DF, etc" }
    validates_with MyValidator

    has_many :allocations
    has_many :items

    STATES_BR = %w(AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO)

    def to_s
      (state.to_s + " " + city.to_s + " " + other.to_s).strip
    end

    def current_items
      self.items.order(created_at: :desc)
    end
end
