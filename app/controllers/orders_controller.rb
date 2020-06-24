class OrdersController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    if @current_user.role == "user"
      @orders = Order.of_user(current_user)
      @user_delivered = Order.user_delivered(current_user)
      @all_orders = Order.all_user(current_user).all_orders()
    elsif @current_user.role == "clerk" || @current_user.role == "owner"
      @orders = Order.received_orders
      @delivered = Order.delivered_orders
      @all_orders = Order.all_orders()
    end

    render :index, locals: { cart: @orders,
                            user_role: @current_user.role,
                            delivered: @delivered,
                            user_delivered: @user_delivered,
                            all_orders: @all_orders }
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
    time = Time.new
    order.delivered_at = time.strftime("%I:%M %p")
    order.save!

    redirect_to orders_path
  end

  def show
    id = params[:id]
    @order = Order.find(id)
    @order_items = OrderItem.current_order_items(@order)
    @customer = walk_in_customer
    render :show, locals: { order: @order,
                            order_items: @order_items,
                            customer: @customer,
                            user_role: @current_user.role }
  end

  def repeat_order
    id1 = params[:id1]
    id2 = params[:id2]
    order1 = Order.find(id1)
    order2 = Order.find(id2)
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
    order = Order.find(id)
    order.destroy
    redirect_to orders_path
  end
end
