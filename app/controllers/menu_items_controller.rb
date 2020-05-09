class MenuItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    render "index"
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
end
