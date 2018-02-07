class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all.page params[:page]

    if params.key? :item
      unless params[:item][:parkable_item_type].blank?
        if params[:item][:parkable_item_type] == "DvrDevice"
          @items.joins("INNER JOIN dvr_devices on items.parkable_item_id = dvr_devices.id").select("dvr_devices.*")
          @items = @items.where "dvr_devices.number_of_channels = #{params[:item][:parkable_item][:number_of_channels]}" unless params[:item][:parkable_item][:number_of_channels].blank?
        elsif params[:item][:parkable_item_type] == "NetworkDevice"
          @items.joins("INNER JOIN network_devices on items.parkable_item_id = network_devices.id").select("network_devices.*")
          @items = @items.where "network_devices.number_of_channels = #{params[:item][:parkable_item][:number_of_channels]}" unless params[:item][:parkable_item][:number_of_channels].blank?
        elsif params[:item][:parkable_item_type] == "Screen"
          @items.joins("INNER JOIN screens on items.parkable_item_id = screens.id").select("screens.*")
          @items = @items.where "screens.inches = #{params[:item][:parkable_item][:inches]}" unless params[:item][:parkable_item][:inches].blank?
        elsif params[:item][:parkable_item_type] == "Printer"
          @items.joins("INNER JOIN printers on items.parkable_item_id = printers.id").select("printers.*")
          @items = @items.where "printers.functions = #{params[:item][:parkable_item][:functions]}" unless params[:item][:parkable_item][:functions].blank?
          @items = @items.where "printers.connection = #{params[:item][:parkable_item][:connection]}" unless params[:item][:parkable_item][:connection].blank?
          @items = @items.where "printers.paint = #{params[:item][:parkable_item][:paint]}" unless params[:item][:parkable_item][:paint].blank?
        elsif params[:item][:parkable_item_type] == "Computer"
          @items.joins("INNER JOIN computers on items.parkable_item_id = computers.id").select("computers.*")
          @items = @items.where "computers.processor = #{params[:item][:parkable_item][:processor]}" unless params[:item][:parkable_item][:processor].blank?
          @items = @items.where "computers.harddrive = #{params[:item][:parkable_item][:harddrive]}" unless params[:item][:parkable_item][:harddrive].blank?
          @items = @items.where "computers.memory = #{params[:item][:parkable_item][:memory]}" unless params[:item][:parkable_item][:memory].blank?
        end
      end
      @items = @items.where plate: params[:item][:plate] unless params[:item][:plate].blank?
      @items = @items.where "items.brand like '%#{params[:item][:brand]}%'" unless params[:item][:brand].blank?
      @items = @items.where "items.model like '%#{params[:item][:model]}%'" unless params[:item][:model].blank?
      @items = @items.where isDischarged: params[:item][:isDischarged] == "true" unless params[:item][:isDischarged].blank?
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @allocations = @item.allocations.order(date: :desc, created_at: :desc).page(params[:al_page]).per(5)
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.dischargeDescription = "" unless @item.isDischarged
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item de inventário foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @item.dischargeDescription = "" unless @item.isDischarged
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Informações atualizadas com sucesso.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Registro excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @item = Item.where("plate = ?", params[:id]).first
      raise ActiveRecord::RecordNotFound unless @item
    end

    def admin_or_mine
      unless current_user.isAdmin or @item.allocations.order('created_at DESC').first.operator == current_user
        redirect_to :root, notice: "Voce não tem permissão para acessar esta página!"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:id, :plate, :brand, :model, :serial, :value, :parkable_item_type, :isDischarged, :dischargeDescription,
        :parkable_item => [:id, :inches, :processor, :memory, :harddisk])
    end
end
