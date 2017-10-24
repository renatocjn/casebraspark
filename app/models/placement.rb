
class MyValidator < ActiveModel::Validator
  def validate(record)
    unless (record.state.to_s + record.city.to_s + record.other.to_s).size > 0
      record.errors[:state] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
    end
  end
end

class Placement < ActiveRecord::Base
    #attr_accessible :description

    validates :contact, :address, presence: :true
    validates :state, length: { is: 2, allow_nil: true, allow_blank: true, message: "Deve ser no formato de UF, ex: CE, DF, etc" }
    validates_with MyValidator

    has_many :allocations
    has_many :items, through: :allocations

    def to_s
      state.to_s + " " + city.to_s + " " + other.to_s
    end
end
