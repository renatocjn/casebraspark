class Placement < ActiveRecord::Base

  has_many :allocations, foreign_key: :destination_id
  has_many :acquisitions, through: :allocations
  has_many :items
  has_many :stock_item_counts, dependent: :destroy
  has_many :stock_items, through: :stock_item_counts

  validates :contact, :address, presence: :true
  STATES_BR = %w(AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO)
  validates :state, inclusion: { in: Placement::STATES_BR, allow_nil: true, allow_blank: true, message: "Deve ser no formato de UF, ex: CE, DF, etc" }
  validate :check_description

  before_destroy do
    raise "O local só pode ser apagado caso não existam mais itens nele" unless self.item_count == 0
    raise "O estoque não pode ser destruído" if self == Placement::stock
  end

  def check_description
    self.errors.add :base, 'Você deve fornecer o estado, a cidade ou outra informação para descrever o local' if [state, city, other].all? {|w| w.blank?}
  end

  def Placement::stock
    Placement.where(other: "Estoque").first
  end

  def description
    (state.to_s + " " + city.to_s + " " + other.to_s).strip
  end

  def to_s
    description
  end

  def item_count
    items.count + stock_item_counts.reduce(0) {|acc, item_count| acc += item_count.count}
  end

  def type_count
      items.select(:id, :parkable_item_type).group(:parkable_item_type).count(:id).each_with_object(Hash.new) do |i, hash|
          hash[Item::TYPES_TRANSLATIONS[i[0]]] = i[1]
      end
  end

  def discharge_stock_items(params)
    self.transaction do
      stock_item_count = self.stock_item_counts.where(stock_item_id: params[:stock_item_id]).first
      if stock_item_count.nil?
        raise "Item de estoque não encontrado para descarte"
      else
        if params[:count].to_i <= 0
          raise "Quantidade de descarte deve ser positiva"
        elsif stock_item_count.count > params[:count].to_i
          stock_item_count.update count: stock_item_count.count - params[:count].to_i
        else
          stock_item_count.destroy
        end
      end
    end
  end
end
