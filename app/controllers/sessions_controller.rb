class SessionsController < ApplicationController
  def new
    if signed_in?
      if params[:game]
        redirect_to register_game_path(params[:game])
      else
        redirect_to root_path
      end
    else
      if params[:game]
        @game = Game.find_by(permalink: params[:game])
      end
      @title = "Sign in"
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if params[:game]
        redirect_to register_game_path(params[:game])
      else
        redirect_to user
      end
    else
      @game = Game.find_by(permalink: params[:game])
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
