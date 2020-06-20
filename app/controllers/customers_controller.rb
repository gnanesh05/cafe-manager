class CustomersController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @customers = User.customers
    @clerk = User.clerk
    render "index"
  end

  def report
    from_date = params[:from_date].presence || DateTime.now - 30
    to_date = params[:to_date].presence || DateTime.now
    if from_date.to_date > to_date.to_date
      from_date = to_date.to_date - 30
    end
    render :show_report, locals: { from_date: from_date,
                                   to_date: to_date }
  end

  def show_report
    date1 = params[:from_date]
    date2 = params[:to_date]
    @reports = Order.getorders(date1, date2)
    redirect_to report_path
  end
end
