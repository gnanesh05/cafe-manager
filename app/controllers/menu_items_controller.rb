class MenuItemsController < ApplicationController
  def index
    if @current_user.role == "user"
      order = Order.current_order(current_user)
      @order = order
      @order_items = OrderItem.where("order_id = ?", order.id)

      render "index"
    end
    if @current_user.role == "clerk"
      @customer = walk_in_customer
      order = Order.current_order(@customer)
      @order = order
      @order_items = OrderItem.where("order_id = ?", order.id)
      render "index"
    end

    menu = Menu.all
  end

  def create
    name = params[:item]
    price = params[:rate]
    description = params[:description]
    image = params[:image]
    category = params[:category]
    menu = params[:menu]

    new_item = MenuItem.new(name: name,
                            price: price,
                            description: description,
                            category_name: category,
                            menu_id: menu,
                            image: image)
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
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.destroy
    redirect_to menu_items_path
  end
end
