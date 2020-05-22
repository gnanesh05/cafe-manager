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

  def update
    id = params[:id]
    user = User.find(id)
    user.role = "clerk"

    if user.save!
      flash[:notice] = " successfully updated #{user.name} to clerk"
      redirect_to customers_path
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_to customers_path
    end
  end

  def change_role
    id = params[:id]
    user = User.find(id)
    user.role = "user"

    if user.save!
      flash[:notice] = " successfully updated #{user.name} to user"
      redirect_to customers_path
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_to customers_path
    end
  end

  def destroy
    id = params[:id]
    user = User.find(id)

    if user.destroy
      flash[:notice] = " successfully removed #{user.name}"
      redirect_to customers_path
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_to customers_path
    end
  end
end
