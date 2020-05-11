class MenusController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    render "index"
  end

  def create
    name = params[:menu]
    new_menu = Menu.new(name: name)
    if new_menu.save
      flash[:notice] = "added a new menu menu"
      redirect_to menus_path
    else
      flash[:error] = new_menu.errors.full_messages.join(", ")
      redirect_to menus_path
    end
  end

  def set
    Rails.cache.write("current_menu_id", params[:menu_id])
    current_menu
    redirect_to menu_items_path
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
    redirect_to menus_path
  end
end
