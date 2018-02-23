class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /allocations
  # GET /allocations.json
  def index
    @allocations = Allocation.all.order(date: :desc, created_at: :desc).page params[:page]

    if params.key? :filter
      @allocations = @allocations.where "date >= ?", Date.parse(filter_params[:initial_date]) unless filter_params[:initial_date].blank?
      @allocations = @allocations.where "date <= ?", Date.parse(filter_params[:final_date])   unless filter_params[:final_date].blank?
      @allocations = @allocations.where operator: filter_params[:operator]                    unless filter_params[:operator].blank?
      @allocations = @allocations.where destination: filter_params[:destination]              unless filter_params[:destination].blank?
      @allocations = @allocations.where origin: filter_params[:origin]                        unless filter_params[:origin].blank?
      @allocations = @allocations.where "reason like '%#{filter_params[:reason]}%'"           unless filter_params[:reason].blank?
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
    @allocation = Allocation.create_from_plates allocation_params
    @allocation.operator = @current_user
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
    respond_to do |format|
      if @allocation.destroy_with_acquisition_if_present
        format.html { redirect_to allocations_url, notice: 'Alocação excluída.' }
        format.json { head :no_content }
      else
        format.html { redirect_to allocations_url, alert: @allocation.errors[:base].join("\n") }
        format.json { head :no_content }
      end
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
      params.require(:filter).permit(:initial_date, :final_date, :origin, :destination, :operator, :reason)
    end
end