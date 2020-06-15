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
    time = Time.now
    order.delivered_at = Time.now.utc.getlocal.strftime("%I:%M%p")
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
    id2 = params[:id2]
    order2 = Order.find(id2)
    order2.status = "not placed"
    redirect_to order_items_path
  end

  def destroy
    id = params[:id]
    order = Order.of_user(current_user).find(id)
    order.destroy
    redirect_to menus_path
  end
end
