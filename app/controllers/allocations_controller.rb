class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :podeAlocar
  before_filter :admin_or_mine, except: [:index, :new, :create]

  # GET /allocations
  # GET /allocations.json
  def index
    if current_user.isAdmin
      @allocations = Allocation.all.page params[:page]
    else
      @allocations = current_user.allocations.page params[:page]
    end

    if params.key? :allocation
      @allocations = @allocations.where "date >= ?", Date.parse(params[:allocation][:initial_date]) unless params[:allocation][:initial_date].blank?
      @allocations = @allocations.where "date <= ?", Date.parse(params[:allocation][:final_date]) unless params[:allocation][:final_date].blank?
      @allocations = @allocations.where operator: params[:allocation][:operator] unless params[:allocation][:operator].blank?
      @allocations = @allocations.where destination: params[:allocation][:destination] unless params[:allocation][:destination].blank?
      @allocations = @allocations.where origin: params[:allocation][:origin] unless params[:allocation][:origin].blank?
      @allocations = @allocations.where "reason like '%#{params[:allocation][:reason]}%'" unless params[:allocation][:reason].blank?
    end
  end

  # GET /allocations/1
  # GET /allocations/1.json
  def show
    @items = @allocation.items.page(params[:items_page]).per(5)
    @stock_item_groups = @allocation.stock_item_groups.page(params[:stock_items_page]).per(5)
  end

  # GET /allocations/new
  def new
    @allocation = Allocation.new
  end

  # GET /allocations/1/edit
  def edit
  end

  # POST /allocations
  # POST /allocations.json
  def create
    unless allocation_params.include? :items_attributes or allocation_params.include? :stock_item_groups_attributes
      redirect_to new_allocation_path, alert: "Voce deve cadastrar pelo menos um item"
    else
      if allocation_params.include? :items_attributes
      items = allocation_params[:items_attributes].values.each_with_object([]) {|item, items_list| items_list.push item[:plate] unless item[:_destroy] == "true"}
        logger.debug "Placas enviadas: " + allocation_params[:items_attributes].values.inspect
        logger.debug "Placas selecionadas: " + items.inspect

        items = Item.where(plate: items)
        allocation_params.delete :items_attributes

        @allocation = Allocation.new(allocation_params)
        @allocation.items = items
      else
        @allocation = Allocation.new(allocation_params)
      end
      @allocation.operator = current_user
      respond_to do |format|
        if @allocation.save
          format.html { redirect_to @allocation, notice: 'Alocação cadastrada com sucesso.' }
          format.json { render :show, status: :created, location: @allocation }
        else
          format.html { render :new }
          format.json { render json: @allocation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /allocations/1
  # PATCH/PUT /allocations/1.json
  def update
    respond_to do |format|
      if @allocation.update(allocation_params)
        @allocation.items.each {|i| i.update placement: @allocation.destination }
        format.html { redirect_to @allocation, notice: 'Alocação cadastrada com sucesso.' }
        format.json { render :show, status: :ok, location: @allocation }
      else
        format.html { render :edit }
        format.json { render json: @allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /allocations/1
  # DELETE /allocations/1.json
  def destroy
    @allocation.destroy
    respond_to do |format|
      format.html { redirect_to allocations_url, notice: 'Alocação excluída.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_allocation
      @allocation = Allocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allocation_params
      params.require(:allocation).permit(:reason, :origin_id, :destination_id, :date,
        :items_attributes => [:id, :plate, :_destroy],
        :stock_item_groups_attributes => [:stock_item_id, :quantity, :_destroy])
    end

    def admin_or_mine
      redirect_to :root, alert: "Você não tem permissão para acessar esta página!" unless current_user.isAdmin or @allocation.operator == current_user
    end
end
