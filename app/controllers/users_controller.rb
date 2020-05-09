class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    render "users/new"
  end

  def create
    new_user = User.new(name: params[:name],
                        email: params[:email],
                        password: params[:password])
    if new_user.save
      flash[:notice] = " successfully registered"
      redirect_to sessions_path
    else
      flash[:error] = new_user.errors.full_messages.join(", ")
      redirect_to users_path
    end
  end
end
