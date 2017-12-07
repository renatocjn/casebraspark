class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    user = Operator.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.

    if user.nil?
      redirect_to "/login", notice: "O email '#{params[:email]}' não pôde ser encontrado"
    elsif user.isBlocked
      redirect_to "/login", notice: "Usuário bloqueado"
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/login', notice: "A senha fornecida é incorreta"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
