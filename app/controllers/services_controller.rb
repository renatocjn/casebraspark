class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  before_action :apenasAdmin, except: [:index, :show]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all.order(send_date: :desc, created_at: :desc).page(params[:page])
    @suppliers = Supplier.all

    if params.include? :filter
      @services = @services.where "send_date >= ?", Date.parse(filter_params[:send_date_initial]) unless filter_params[:send_date_initial].blank?
      @services = @services.where "send_date <= ?", Date.parse(filter_params[:send_date_final])   unless filter_params[:send_date_final].blank?
      @services = @services.where "recv_date >= ?", Date.parse(filter_params[:recv_date_initial]) unless filter_params[:recv_date_initial].blank?
      @services = @services.where "recv_date <= ?", Date.parse(filter_params[:recv_date_final])   unless filter_params[:recv_date_final].blank?
      @services = @services.where "value >= ?", filter_params[:value_min]   unless filter_params[:value_min].blank?
      @services = @services.where "value <= ?", filter_params[:value_max]   unless filter_params[:value_max].blank?
      @services = @services.where supplier: filter_params[:supplier]        unless filter_params[:supplier].blank?
      if filter_params[:completed] == "Sim"
        @services = @services.where.not recv_date: nil
      elsif filter_params[:completed] == "Não"
        @services = @services.where recv_date: nil
      end
      @services = @services.where "service_type like '%#{filter_params[:type_or_description]}%' or description like '%#{filter_params[:type_or_description]}%'" unless filter_params[:type_or_description].blank?
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @items = @service.items.page params[:page]
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.create_from_plates(service_params)
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Registro criado com sucesso.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update_from_plates(service_params)
        format.html { redirect_to @service, notice: 'Serviço atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Registro destruído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:service_type, :description, :value, :invoice_id, :invoice_filename, :invoice_content_size,
                                      :invoice_content_type, :send_date, :recv_date, :supplier_id, :invoice,
                                          :items_attributes => [:plate, :_destroy])
    end

    def filter_params
      params.require(:filter).permit(:type_or_description, :send_date_initial, :send_date_final, :recvb_date_initial, :recv_date_final,
                                      :value_min, :value_max, :recv_date_final)
    end
end
