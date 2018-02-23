class PlacementsController < ApplicationController
  before_action :set_placement, only: [:show, :edit, :update, :destroy, :stock_items]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /placements
  # GET /placements.json
  def index
    @placements = Placement.all.page params[:page]

    if params.key? :placement
      @placement = @placement.where "state like '%#{params[:placement][:state]}%'" unless params[:placement][:state].blank?
      @placement = @placement.where "city like '%#{params[:placement][:city]}%'" unless params[:placement][:city].blank?
      @placement = @placement.where "other like '%#{params[:placement][:other]}%'" unless params[:placement][:other].blank?
    end
  end

  # GET /placements/1
  # GET /placements/1.json
  def show
    @stock_item_counts = @placement.stock_item_counts.page(params[:stock_items_page]).per(5)
    @type_counts = Kaminari.paginate_array(@placement.type_count.to_a).page(params[:sum_items_page]).per(5)
    @items = @placement.items.page(params[:items_page]).per(5)
    @allocations = @placement.allocations.order(date: :desc).page(params[:al_page]).per(5)
    @acquisitions = @placement.acquisitions.joins(:allocation).order("allocations.date DESC").page(params[:ac_page]).per(5)
  end

  # GET /placements/new
  def new
    @placement = Placement.new
  end

  # GET /placements/1/edit
  def edit
  end

  # POST /placements
  # POST /placements.json
  def create
    @placement = Placement.new(placement_params)
    respond_to do |format|
      if @placement.save
        format.html { redirect_to @placement, notice: 'Novo local registrado com sucesso' }
        format.json { render :show, status: :created, location: @placement }
      else
        format.html { render :new }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placements/1
  # PATCH/PUT /placements/1.json
  def update
    respond_to do |format|
      if @placement.update(placement_params)
        format.html { redirect_to @placement, notice: 'Informações atualizadas com sucesso' }
        format.json { render :show, status: :ok, location: @placement }
      else
        format.html { render :edit }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placements/1
  # DELETE /placements/1.json
  def destroy
    respond_to do |format|
      begin
        @placement.destroy
        format.html { redirect_to placements_url, notice: 'O registro foi excluido com sucesso' }
        format.json { head :no_content }
      rescue RuntimeError => ex
        format.html { redirect_to placements_url, alert: ex.message }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /placements/1/stock_items
  def stock_items
    respond_to do |format|
      begin
        @placement.discharge_stock_items(discharge_stock_items_params)
        format.html { redirect_to @placement, notice: 'Informações atualizadas com sucesso' }
      rescue RuntimeError => err
        format.html { redirect_to @placement, alert: err.message }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placement
      @placement = Placement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      params.require(:placement).permit(:state, :city, :other, :address, :contact)
    end

    def discharge_stock_items_params
      params.require(:stock_item_count).permit(:stock_item_id, :count)
    end
end
