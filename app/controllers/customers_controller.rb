class CustomersController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @customers = User.customers
    @clerk = User.clerk
    render "index"
  end

  def report
    from_date = params[:from_date].presence || Date.today - 10
    to_date = params[:to_date].presence || Date.today
    if from_date.to_date > to_date.to_date
      from_date = to_date.to_date - 10
    end
    render :show_report, locals: { from_date: from_date,
                                   to_date: to_date }
  end

  def show
    id = params[:id]
    @user = User.find(id)
    if @user.role == "user"
      @orders = Order.user_delivered(@user)
    else
      @walk_in_customer = walk_in_customer
      @orders = Order.user_delivered(@walk_in_customer)
    end
    render "show"
  end
end
