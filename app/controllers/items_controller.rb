class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, only: [:index, :destroy]
  before_filter :admin_or_mine, except: [:index, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all.page params[:page]

    if params.key? :item
      @items = @items.where plate: params[:item][:plate] unless params[:item][:plate].blank?
      @items = @items.where "brand like '%#{params[:item][:brand]}%'" unless params[:item][:brand].blank?
      @items = @items.where "brand like '%#{params[:item][:model]}%'" unless params[:item][:model].blank?
      @items = @items.where isDischarged: params[:item][:isDischarged] unless params[:item][:isDischarged].blank?
      @items = @items.where parkable_item_type: params[:item][:parkable_item_type] unless params[:item][:parkable_item_type].blank?
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
