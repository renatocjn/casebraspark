
class Placement < ActiveRecord::Base

  validates :contact, :address, presence: :true
  validates :state, length: { is: 2, allow_nil: true, allow_blank: true, message: "Deve ser no formato de UF, ex: CE, DF, etc" }
  validate :check_description

  has_many :allocations
  has_many :items

  STATES_BR = %w(AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO)

  def description
    (state.to_s + " " + city.to_s + " " + other.to_s).strip
  end

  def to_s
    description
  end

  def current_items
    self.items.order(created_at: :desc)
  end

  def check_description
    if self.to_s.blank?
      self.errors[:state] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
      self.errors[:city] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
      self.errors[:other] << 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
    end
  end

  def stock
    Placement.where other: "Estoque"
  end
end
