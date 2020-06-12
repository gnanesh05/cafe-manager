class OrderItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    if @current_user.role == "user"
      order = Order.current_order(current_user)
      @order = order
      if order != nil
        @order_items = OrderItem.where("order_id = ?", order.id)
      end

      render "index"
    end
    if @current_user.role == "clerk"
      @customer = walk_in_customer
      order = Order.current_order(@customer)
      @order = order
      if order != nil
        @order_items = OrderItem.where("order_id = ?", order.id)
      end
      render "index"
    end
    if @current_user == nil
      redirect_to users_path
    end
  end

  def add
    id = params[:id]
    order_item = OrderItem.find(id)

    order = Order.current_order(current_user)
    order_item.quantity = order_item.quantity + 1
    order_item.save!
    redirect_back fallback_location: order_items_path
  end

  def remove
    id = params[:id]
    order_item = OrderItem.find(id)

    order = Order.current_order(current_user)
    if order_item.quantity > 0
      order_item.quantity = order_item.quantity - 1
      order_item.save!
      redirect_back fallback_location: order_items_path
    end
    if order_item.quantity == 0
      order_item.delete
    end
  end

  def create_order_item
    id = params[:id]
    item = MenuItem.find(id)
    order = Order.current_order(current_user)
    cart_item = OrderItem.new(
      menu_item_id: id,
      menu_item_name: item.name,
      menu_item_price: item.price,
      quantity: 1,
      order_id: order.id,
    )
    if cart_item.save
      flash[:notice] = "#{item.name} is added to cart"
      redirect_to menu_items_path
    end
  end

  def offline_customer
    @customer = walk_in_customer
    id = params[:id]
    item = MenuItem.find(id)
    order = Order.current_order(@customer)
    cart_item = OrderItem.new(
      menu_item_id: id,
      menu_item_name: item.name,
      menu_item_price: item.price,
      quantity: 1,
      order_id: order.id,
    )
    if cart_item.save
      flash[:notice] = "#{item.name} is added to cart"
      redirect_to menu_items_path
    end
  end

  def destroy
    id = params[:id]
    order_item = OrderItem.find(id)
    order_item.destroy
    redirect_to order_items_path
  end

  def delete
    id = params[:id]
    order_item = OrderItem.find(id)
    order_item.destroy
    redirect_back fallback_location: order_items_path
  end
end
