class MenuItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    render "index"
    menu = Menu.all
  end

  def create
    name = params[:item]
    price = params[:rate]
    description = params[:description]
    category = params[:category]
    menu = params[:menu]

    new_item = MenuItem.new(name: name,
                            price: price,
                            description: description,
                            category_name: category,
                            menu_id: menu)
    if new_item.save
      flash[:notice] = "added a new menu item"
      redirect_to menu_items_path
    else
      flash[:error] = new_item.errors.full_messages.join(", ")
      redirect_to menus_path
    end
  end

  def update
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.name = params[:name]
    menu_item.price = params[:price]
    menu_item.save!
    redirect_to menu_items_path
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.destroy
    redirect_to menu_items_path
  end
end
