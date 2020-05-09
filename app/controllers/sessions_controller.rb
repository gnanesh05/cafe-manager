class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      flash[:notice] = " you're signed in !"
      if user.role == "user"
        new_order = Order.create!(user_id: user.id,
                                  date: Date.today,
                                  status: "not placed")
      end
      redirect_to "/"
    else
      flash[:error] = "your login attempt was invalid. please try again"
      redirect_to new_sessions_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end
