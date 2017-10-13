class SessionsController < ApplicationController

  def new
  end

  def create
    user = Operator.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      logger.info "O usuário #{params[:email]} fez login com sucesso"
      redirect_to '/'
    else
    # If user's login doesn't work, send them back to the login form.
      logger.info "O usuário #{params[:email]} não foi encontrado ou colocou a senha incorreta"
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
