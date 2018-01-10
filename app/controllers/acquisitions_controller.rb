class AcquisitionsController < ApplicationController
  before_action :set_acquisition, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :podeComprar
  before_filter :admin_or_mine, except: [:index, :new, :create]

  # GET /acquisitions
  # GET /acquisitions.json
  def index
    @acquisitions = current_user.isAdmin ? Acquisition.all : current_user.acquisitions
    @acquisitions = @acquisitions.page params[:page]

    if params.key? :acquisition
      @acquisitions = @acquisitions.joins(:allocation).where "allocation.date >= ?", Date.parse(params[:acquisition][:initial_date]) unless params[:acquisition][:initial_date].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "allocation.date <= ?", Date.parse(params[:acquisition][:final_date]) unless params[:acquisition][:final_date].blank?
      @acquisitions = @acquisitions.where operator: params[:acquisition][:operator] unless params[:acquisition][:operator].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "allocations.destination" => params[:acquisition][:destination] unless params[:acquisition][:destination].blank?
      @acquisitions = @acquisitions.where invoice_number: params[:acquisition][:invoice_number] unless params[:acquisition][:invoice_number].blank?
      @acquisitions = @acquisitions.where supplier: params[:acquisition][:supplier] unless params[:acquisition][:supplier].blank?
      @acquisitions = @acquisitions.where company: params[:acquisition][:company] unless params[:acquisition][:company].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "reason like '%#{params[:acquisition][:reason]}%'" unless params[:acquisition][:reason].blank?
    end
  end

  # GET /acquisitions/1
  # GET /acquisitions/1.json
  def show
    @items = @acquisition.allocation.items.page(params[:items_page]).per(5)
    @stock_item_groups = @acquisition.allocation.stock_item_groups.page(params[:stock_items_page]).per(5)
  end

  # GET /acquisitions/new
  def new
    @acquisition = Acquisition.new
    @acquisition.build_allocation
    #@acquisition.allocation.items.build
  end

  # GET /acquisitions/1/edit
  def edit
  end

  # POST /acquisitions
  # POST /acquisitions.json
  def create
    @acquisition = Acquisition.new acquisition_params
    @acquisition.operator = current_user
    respond_to do |format|
      if @acquisition.save
        format.html { redirect_to @acquisition, notice: 'Aquisição registrada com sucesso.' }
        format.json { render :show, status: :created, location: @acquisition }
      else
        format.html { render :new }
        format.json { render json: @acquisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acquisitions/1
  # PATCH/PUT /acquisitions/1.json
  def update
    respond_to do |format|
      if @acquisition.update(acquisition_params)
        format.html { redirect_to @acquisition, notice: 'Aquisição atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @acquisition }
      else
        format.html { render :edit }
        format.json { render json: @acquisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acquisitions/1
  # DELETE /acquisitions/1.json
  def destroy
    @acquisition.destroy
    respond_to do |format|
      format.html { redirect_to acquisitions_url, notice: 'O registro da aquisição foi excluído.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acquisition
      @acquisition = Acquisition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acquisition_params
      params.require(:acquisition).permit(:supplier_id, :company_id, :invoice_number, :invoice, :invoice_id, :invoice_content_size, :invoice_filename, :invoice_content_type,
        :allocation_attributes => [:id, :reason, :destination_id, :date,
          :items_attributes => [:id, :plate, :brand, :model, :serial, :value, :parkable_item_id, :parkable_item_type, :_destroy,
            :parkable_item_attributes => [:id, :inches, :processor, :memory, :harddrive, :connection, :functions, :paint, :number_of_channels, :function]],
          :stock_item_groups_attributes => [:id, :stock_item_id, :quantity, :unit_value, :_destroy]])
    end

    def admin_or_mine
      redirect_to :root unless current_user.isAdmin or @acquisition.operator == current_user
    end
end
