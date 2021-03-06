class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      flash[:notice] = " Hi #{user.name} !"

      if user.role == "user"
        order = Order.current_order(user)
        if order == nil
          new_order = Order.create!(user_id: user.id,
                                    date: Date.today,
                                    status: "not placed")
        end
        redirect_to menu_items_path
      elsif user.role == "clerk"
        @customer = walk_in_customer
        order = Order.current_order(@customer)
        if order == nil
          new_order = Order.create!(user_id: @customer.id,
                                    date: Date.today,
                                    status: "not placed")
        end
        redirect_to menu_items_path
      else
        redirect_to "/"
      end
    else
      flash[:error] = "your login attempt was invalid. please try again"
      redirect_to new_sessions_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
    flash[:notice] = "come back soon!"
  end
end
