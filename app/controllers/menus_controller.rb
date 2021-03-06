class MenusController < ApplicationController
  before_action :ensure_owner_logged_in
  before_action :current_menu

  def index
    @menu = Menu.all
    render :index, locals: { menu: @menu }
  end

  def create
    name = params[:menu]
    new_menu = Menu.new(name: name)
    if new_menu.save
      flash[:notice] = "added a new menu- #{new_menu.name}"
      redirect_to menus_path
    else
      flash[:error] = new_menu.errors.full_messages.join(", ")
      redirect_to menus_path
    end
  end

  def edit
    id = params[:id]
    @edit_menu = Menu.find(id)
    @menu_items = MenuItem.of_menu(@edit_menu)
    render "menus/edit"
  end

  def set
    Rails.cache.write("current_menu_id", params[:menu_id])
    redirect_to menu_items_path
  end

  def destroy
    id = params[:id]
    menu_to_be_delted = Menu.find(id)
    if current_menu == menu_to_be_delted && current_menu
      list_menu = Menu.find_next_menu(menu_to_be_delted)
      Rails.cache.write("current_menu_id", list_menu.first.id)
      menu_to_be_delted.destroy
    elsif !current_menu
      flash[:error] = "Error - Cannot delete all Menus"
    else
      menu_to_be_delted.destroy
    end
    redirect_to menus_path
  end
end
