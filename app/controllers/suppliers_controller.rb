class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, except: [:show, :index]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all.page params[:page]

    if params.key? :supplier
      @suppliers = @suppliers.where "name like '%#{params[:supplier][:name]}%'" unless params[:supplier][:name].blank?
    end
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
    #@buyable_items = Kaminari.paginate_array(@supplier.get_buyable_items).page(params[:bi_page]).per(5)
    @services = @supplier.services.order(send_date: :desc, created_at: :desc).page(params[:serv_page]).per(5)
    @acquisitions = @supplier.acquisitions.joins(:allocation).order("allocations.date DESC, created_at DESC").page(params[:ac_page]).per(5)
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Fornecedor criado com sucesso.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'Fornecedor atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Fornecedor destruído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:name, :email, :address, :phones, :other)
    end
end
