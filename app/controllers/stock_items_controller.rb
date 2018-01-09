class StockItemsController < ApplicationController
  before_action :set_stock_item, only: [:show, :edit, :update, :destroy]

  # GET /stock_items
  # GET /stock_items.json
  def index
    @stock_items = StockItem.all.page params[:page]

    if params.key? :stock_item
      @stock_items = @stock_items.where "short_description like '%#{params[:stock_item][:short_description]}%'" unless params[:stock_item][:short_description].blank?
    end
  end

  # GET /stock_items/1
  # GET /stock_items/1.json
  def show
    @placements = @stock_item.placements.page(params[:pl_page]).per(5)
    @acquisitions = @stock_item.acquisitions.joins(:allocation).order("allocations.date DESC").page(params[:ac_page]).per(5)
  end

  # GET /stock_items/new
  def new
    @stock_item = StockItem.new
  end

  # GET /stock_items/1/edit
  def edit
  end

  # POST /stock_items
  # POST /stock_items.json
  def create
    @stock_item = StockItem.new(stock_item_params)

    respond_to do |format|
      if @stock_item.save
        format.html { redirect_to @stock_item, notice: 'Stock item was successfully created.' }
        format.json { render :show, status: :created, location: @stock_item }
      else
        format.html { render :new }
        format.json { render json: @stock_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_items/1
  # PATCH/PUT /stock_items/1.json
  def update
    respond_to do |format|
      if @stock_item.update(stock_item_params)
        format.html { redirect_to @stock_item, notice: 'Stock item was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock_item }
      else
        format.html { render :edit }
        format.json { render json: @stock_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_items/1
  # DELETE /stock_items/1.json
  def destroy
    @stock_item.destroy
    respond_to do |format|
      format.html { redirect_to stock_items_url, notice: 'Stock item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_item
      @stock_item = StockItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_item_params
      params.require(:stock_item).permit(:short_description, :long_description, :stock)
    end
end
