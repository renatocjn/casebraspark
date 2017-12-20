class StockItemsTypesController < ApplicationController
  before_action :set_stock_items_type, only: [:show, :edit, :update, :destroy]

  # GET /stock_items_types
  # GET /stock_items_types.json
  def index
    @stock_items_types = StockItemsType.all
  end

  # GET /stock_items_types/1
  # GET /stock_items_types/1.json
  def show
  end

  # GET /stock_items_types/new
  def new
    @stock_items_type = StockItemsType.new
  end

  # GET /stock_items_types/1/edit
  def edit
  end

  # POST /stock_items_types
  # POST /stock_items_types.json
  def create
    @stock_items_type = StockItemsType.new(stock_items_type_params)

    respond_to do |format|
      if @stock_items_type.save
        format.html { redirect_to @stock_items_type, notice: 'Stock items type was successfully created.' }
        format.json { render :show, status: :created, location: @stock_items_type }
      else
        format.html { render :new }
        format.json { render json: @stock_items_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_items_types/1
  # PATCH/PUT /stock_items_types/1.json
  def update
    respond_to do |format|
      if @stock_items_type.update(stock_items_type_params)
        format.html { redirect_to @stock_items_type, notice: 'Stock items type was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock_items_type }
      else
        format.html { render :edit }
        format.json { render json: @stock_items_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_items_types/1
  # DELETE /stock_items_types/1.json
  def destroy
    @stock_items_type.destroy
    respond_to do |format|
      format.html { redirect_to stock_items_types_url, notice: 'Stock items type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_items_type
      @stock_items_type = StockItemsType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_items_type_params
      params.require(:stock_items_type).permit(:description)
    end
end
