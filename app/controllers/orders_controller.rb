class OrdersController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    if @current_user.role == "user"
      @orders = Order.of_user(current_user)
      @user_delivered = Order.user_delivered(current_user)
      render "index"
    end
    if @current_user.role == "clerk" || @current_user.role == "owner"
      @orders = Order.received_orders
      @delivered = Order.delivered_orders
      render "index"
    end
    if @current_user == nil
      redirect_to users_path
    end
  end

  def create
    Order.create!(user_id: @current_user.id,
                  date: Date.today,
                  status: "not placed")
    redirect_to menu_items_path
  end

  def update
    id = params[:id]
    order = Order.find(id)
    order.status = "received"
    order.save!
    redirect_to orders_path
  end

  def deliver_order
    id = params[:id]
    order = Order.find(id)
    order.status = "delivered"
    order.delivered_at = DateTime.now.strftime("%H:%M")
    order.save!

    redirect_to orders_path
  end

  def show
    id = params[:id]
    @order = Order.find(id)
    @order_items = OrderItem.current_order_items(@order)
    @customer = walk_in_customer
    render "show"
  end

  def repeat_order
    id1 = params[:id1]
    order1 = Order.find(id1)
    order2 = Order.create!(user_id: order1.user_id,
                           date: Date.today,
                           status: "not placed")
    order_items = OrderItem.current_order_items(order1)
    order_items.each do |item|
      order_item = OrderItem.find(item.id)
      order = Order.find(order2.id)
      menu_item_id = order_item.menu_item_id
      menu_item = MenuItem.find(menu_item_id)
      repeat_item = OrderItem.create!(
        menu_item_id: menu_item.id,
        menu_item_name: menu_item.name,
        menu_item_price: order_item.menu_item_price,
        quantity: order_item.quantity,
        order_id: order.id,
      )
    end
    redirect_to order_items_path
  end

  def destroy
    id = params[:id]
    order = Order.of_user(current_user).find(id)
    order.destroy
    redirect_to menus_path
  end
end
