class CustomersController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @customers = User.customers
    @clerk = User.clerk
    render "index"
  end

  def report
    @customers = User.customers
    @clerk = User.clerk
    @all_orders = Order.delivered_orders
    render "show_report"
  end

  def show_report
    date1 = params[:from_date]
    @orders = Order.report_orders(date1)
    redirect_to report_path
  end
end
