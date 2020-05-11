class ApplicationController < ActionController::Base
  before_action :ensure_user_logged_in
  before_action :current_menu

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
end
