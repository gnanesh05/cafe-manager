class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    render "users/new"
  end

  def create
    new_user = User.new(name: params[:name],
                        email: params[:email],
                        password: params[:password],
                        address: params[:address])
    name = params[:name]
    if name != "Walk-in customer"
      if new_user.save
        flash[:notice] = " successfully registered"
        session[:current_user_id] = new_user.id
        redirect_to menu_items_path
      else
        flash[:error] = new_user.errors.full_messages.join(", ")
        redirect_to users_path
      end
    else
      flash[:error] = "Invalid Name"
      redirect_to users_path
    end
  end

  def update
    id = params[:id]
    user = User.find(id)
    user.role = "clerk"

    if user.save
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

    if user.save
      flash[:notice] = " successfully updated #{user.name} to user"
      redirect_to customers_path
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_to customers_path
    end
  end

  def show
    id = params[:id]
    @user = User.find(id)
    render "show"
  end

  def change_identity
    id = params[:id]
    user = User.find(id)
    user.name = params[:name]
    user.address = params[:address]
    user.save!
    flash[:notice] = "updated account details"
    redirect_to "/"
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
