class OperatorsController < ApplicationController
  before_action :set_operator, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  before_filter :apenasAdmin, only: [:index, :new, :create]
  before_filter :admin_or_me, except: [:index, :new, :create]

  # GET /operators
  # GET /operators.json
  def index
    @operators = Operator.all.page params[:page]

    if params.key? :operator
      @operators = @operators.where "name like '%#{params[:operator][:name]}%'" unless params[:operator][:name].blank?
      @operators = @operators.where "email like '%#{params[:operator][:email]}%'" unless params[:operator][:email].blank?
      @operators = @operators.where canAlocate: params[:operator][:canAlocate] == "true" unless params[:operator][:canAlocate].blank?
      @operators = @operators.where canBuy: params[:operator][:canBuy] == "true" unless params[:operator][:canBuy].blank?
      @operators = @operators.where isAdmin: params[:operator][:isAdmin] == "true" unless params[:operator][:isAdmin].blank?
      @operators = @operators.where isBlocked: params[:operator][:isBlocked] == "true" unless params[:operator][:isBlocked].blank?
    end
  end

  # GET /operators/1
  # GET /operators/1.json
  def show
    @allocations = @operator.allocations.order(date: :desc).page(params[:al_page]).per(5)
    @acquisitions = @operator.acquisitions.order(date: :desc).page(params[:ac_page]).per(5)
  end

  # GET /operators/new
  def new
    @operator = Operator.new
  end

  # GET /operators/1/edit
  def edit
  end

  # POST /operators
  # POST /operators.json
  def create
    @operator = Operator.new(operator_params)
    #if @operator.save
    #  session[:user_id] = @operator.id
    #end

    respond_to do |format|
      if @operator.save
        format.html { redirect_to @operator, notice: 'Operador criado com sucesso.' }
        format.json { render :show, status: :created, location: @operator }
      else
        format.html { render :new }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /operators/1
  # PATCH/PUT /operators/1.json
  def update
    respond_to do |format|
      if @operator.update(operator_params)
        format.html { redirect_to @operator, notice: 'Informações atualizadas com sucesso.' }
        format.json { render :show, status: :ok, location: @operator }
      else
        format.html { render :edit }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operators/1
  # DELETE /operators/1.json
  def destroy
    @operator.destroy
    respond_to do |format|
      format.html { redirect_to operators_url, notice: 'Informações excluídas.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator
      @operator = Operator.find(params[:id])
    #rescue ActiveRecord::RecordNotFound
    #  not_found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operator_params
      params.require(:operator).permit(:name, :login, :email, :password, :password_confirmation, :canAlocate, :canBuy, :isAdmin, :isBlocked)
    end

    def admin_or_me
      redirect_to :root, notice: "Você não tem permissão para acessar esta página!" unless @operator == current_user or current_user.isAdmin
    end
end
