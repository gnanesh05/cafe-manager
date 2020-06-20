class ReportsController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @all_orders = Order.delivered_orders
    render "index"
  end

  def display_report
    date1 = params[:from_date]
    @orders = Order.delivered_orders.report_orders(date1)
    redirect_to report_index_path
  end
end
