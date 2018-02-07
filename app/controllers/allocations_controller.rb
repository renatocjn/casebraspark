class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /allocations
  # GET /allocations.json
  def index
    @allocations = Allocation.all.page params[:page]

    if params.key? :allocation
      @allocations = @allocations.where "date >= ?", Date.parse(params[:allocation][:initial_date]) unless params[:allocation][:initial_date].blank?
      @allocations = @allocations.where "date <= ?", Date.parse(params[:allocation][:final_date])   unless params[:allocation][:final_date].blank?
      @allocations = @allocations.where operator: params[:allocation][:operator]                    unless params[:allocation][:operator].blank?
      @allocations = @allocations.where destination: params[:allocation][:destination]              unless params[:allocation][:destination].blank?
      @allocations = @allocations.where origin: params[:allocation][:origin]                        unless params[:allocation][:origin].blank?
      @allocations = @allocations.where "reason like '%#{params[:allocation][:reason]}%'"           unless params[:allocation][:reason].blank?
    end
  end

  # GET /allocations/1
  # GET /allocations/1.json
  def show
    if @allocation.is_acquisition
      redirect_to @allocation.acquisition
    else
      @items = @allocation.items.page(params[:items_page]).per(5)
      @type_counts = Kaminari.paginate_array(@allocation.type_count.to_a).page(params[:sum_items_page]).per(5)
      @stock_item_groups = @allocation.stock_item_groups.page(params[:stock_items_page]).per(5)
    end
  end

  # GET /allocations/new
  def new
    @allocation = Allocation.new
  end

  # GET /allocations/1/edit
  def edit
    if @allocation.is_acquisition
      redirect_to edit_acquisition_url(@allocation.acquisition)
    end
  end

  # POST /allocations
  # POST /allocations.json
  def create
    #FIXME fix problems with create_from_plates where the user only gets the stock_items wrong
    params[:allocation][:operator_id] = current_user.id
    @allocation = Allocation.create_from_plates allocation_params
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

  # PATCH/PUT /allocations/1
  # PATCH/PUT /allocations/1.json
  def update
    #FIXME fix problems with update_from_plates where the user only gets the stock_items wrong
    respond_to do |format|
      if @allocation.update_from_plates(allocation_params)
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
    if @allocation.is_acquisition
      @allocation.acquisition.destroy
    else
      @allocation.destroy
    end
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
      params.require(:allocation).permit(:reason, :origin_id, :destination_id, :date, :operator_id,
        :items_attributes => [:id, :plate, :_destroy],
        :stock_item_groups_attributes => [:id, :stock_item_id, :quantity, :_destroy],
        :allocations_items_attributes => [:id, :plate, :item_id])
    end

    def filter_params
      #TODO strong params for filter form on allocation index
      params.require(:filter).permit()
    end

    #def admin_or_mine
    #  redirect_to :root, alert: "Você não tem permissão para acessar esta página!" unless current_user.isAdmin or @allocation.operator == current_user
    #end
end