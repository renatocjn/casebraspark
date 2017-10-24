class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id] and Operator.find(session[:user_id])
      @current_user ||= Operator.find(session[:user_id])
    else
      redirect_to logout_path
    end
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def apenasAdmin
    redirect_to :root, notice: "Apenas usuários administradores podem acessar a página!" unless current_user.isAdmin
  end

  def podeAlocar
    redirect_to :root, notice: "Você não tem autorização para cadastrar alocações!" unless current_user.isAdmin or current_user.canAlocate
  end

  def podeComprar
    redirect_to :root, notice: "Voce não tem autorização para cadastrar aquisições!" unless current_user.isAdmin or current_user.canBuy
  end

  #def not_found
  #  raise ActionController::RoutingError.new('Not Found')
  #end
end
