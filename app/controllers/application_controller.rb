class ApplicationController < ActionController::Base
  before_action :ensure_user_logged_in
  before_action :current_menu
  helper_method :repeat_order_item

  def ensure_user_logged_in
    unless current_user
      redirect_to sessions_path
    end
  end

  def current_user
    return @current_user if @current_user
    current_user_id = session[:current_user_id]
    if current_user_id
      @current_user = User.find(current_user_id)
    else
      nil
    end
  end

  def walk_in_customer
    return @walk_in_customer = User.find_by(name: "walk-in customer")
  end

  def ensure_clerk_logged_in
    unless current_user.role == "clerk"
      redirect_to sessions_path
    end
  end

  def ensure_owner_logged_in
    unless current_user.role == "owner"
      redirect_to sessions_path
    end
  end

  def current_menu
    if Rails.cache.fetch("current_menu_id")
      @current_menu_id = Rails.cache.read("current_menu_id")
      return @menu = Menu.find(@current_menu_id)
    else
      Rails.cache.write("current_menu_id", Menu.first.id)
      @current_menu_id = Rails.cache.read("current_menu_id")
      return @menu = Menu.find(@current_menu_id)
    end
  end

  def repeat_order_item(id1, id2)
    order_item = OrderItem.find(id1)
    order = Order.find(id2)
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
end
