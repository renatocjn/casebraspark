class Placement < ActiveRecord::Base

  has_many :allocations, foreign_key: :destination_id
  has_many :acquisitions, through: :allocations
  has_many :items
  has_many :stock_item_counts
  has_many :stock_items, through: :stock_item_counts

  validates :contact, :address, presence: :true
  STATES_BR = %w(AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO)
  validates :state, inclusion: { in: Placement::STATES_BR, allow_nil: true, allow_blank: true, message: "Deve ser no formato de UF, ex: CE, DF, etc" }
  validate :check_description
  validate :protect_stock, on: :destroy

  validate on: :destroy do |record|
    errors.add :base, "O local só pode ser apagado caso não existam mais itens nele" unless record.items_count == 0
  end

  def check_description
    if [state, city, other].all? {|w| w.blank?}
      self.errors.add 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local'
    end
  end

  def stock
    Placement.where(other: "Estoque").first
  end

  def protect_stock
    errors.add "O estoque não pode ser destruído" if self == Placement.stock
  end

  def description
    (state.to_s + " " + city.to_s + " " + other.to_s).strip
  end

  def to_s
    description
  end

  def current_items
    self.items.order(date: :desc)
  end

  def item_count
    items.count + stock_item_counts.reduce(0) {|acc, item_count| acc += item_count.count}
  end
end
