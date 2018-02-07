class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id] and Operator.find(session[:user_id])
      @current_user ||= Operator.find(session[:user_id])
    else
      redirect_to logout_path, alert: "Seção inválida"
    end
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def apenasAdmin
    redirect_to :back, alert: "Apenas usuários administradores podem realizar esta ação" unless current_user.isAdmin
  end
end
