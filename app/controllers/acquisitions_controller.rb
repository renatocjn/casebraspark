class AcquisitionsController < ApplicationController
  before_action :set_acquisition, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /acquisitions
  # GET /acquisitions.json
  def index
    @acquisitions = Acquisition.all.page params[:page]

    if params.key? :filter
      @acquisitions = @acquisitions.joins(:allocation).where "allocation.date >= ?", Date.parse(filter_params[:initial_date]) unless filter_params[:initial_date].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "allocation.date <= ?", Date.parse(filter_params[:final_date]) unless filter_params[:final_date].blank?
      @acquisitions = @acquisitions.where operator: filter_params[:operator] unless filter_params[:operator].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "allocations.destination" => filter_params[:destination] unless filter_params[:destination].blank?
      @acquisitions = @acquisitions.where invoice_number: filter_params[:invoice_number] unless filter_params[:invoice_number].blank?
      @acquisitions = @acquisitions.where supplier: filter_params[:supplier] unless filter_params[:supplier].blank?
      @acquisitions = @acquisitions.where company: filter_params[:company] unless filter_params[:company].blank?
      @acquisitions = @acquisitions.joins(:allocation).where "reason like '%#{filter_params[:reason]}%'" unless filter_params[:reason].blank?
    end
  end

  # GET /acquisitions/1
  # GET /acquisitions/1.json
  def show
    @items = @acquisition.allocation.items.page(params[:items_page]).per(5)
    @type_counts = Kaminari.paginate_array(@acquisition.type_count.to_a).page(params[:sum_items_page]).per(5)
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
          :items_attributes => [:id, :plate, :brand, :model, :serial, :value, :parkable_item_id, :parkable_item_type, :isDischarged, :_destroy,
            :parkable_item_attributes => [:id, :inches, :processor, :memory, :harddrive, :connection, :functions, :paint, :number_of_channels, :function, :kind]],
          :stock_item_groups_attributes => [:id, :stock_item_id, :quantity, :unit_value, :_destroy]])
    end

    def filter_params
      params.require(:filter).permit(:invoice_number, :initial_date, :company, :supplier, :reason, :final_date, :operator, :destination)
    end

    #def admin_or_mine
    #  redirect_to :root unless current_user.isAdmin or @acquisition.operator == current_user
    #end
end
