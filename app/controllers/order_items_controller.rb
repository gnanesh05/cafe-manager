class OrderItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    if @current_user.role == "user"
      order = Order.current_order(current_user)
      @order = order
      @order_items = OrderItem.where("order_id = ?", order.id)
      render "index"
    else
      redirect_to users_path
    end
  end

  def update
    id = params[:id]
    item = MenuItem.find(id)
    order = Order.current_order(current_user)
    cart_item = OrderItem.new(
      menu_item_id: id,
      menu_item_name: item.name,
      menu_item_price: item.price,
      quantity: params[:quantity],
      order_id: order.id,
    )
    if !cart_item.save
      flash[:error] = cart_item.errors.full_messages.join(", ")
      redirect_to menu_items_path
    end
  end

  def destroy
    id = params[:id]
    order_item = OrderItem.find(id)
    order_item.destroy
    redirect_to order_items_path
  end
end
