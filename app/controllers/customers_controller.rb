class CustomersController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @customers = User.customers
    @clerk = User.clerk
    render "index"
  end

  def report
    from_date = params[:from_date].presence || Date.today - 5
    to_date = params[:to_date].presence || Date.today
    if from_date.to_date > to_date.to_date
      from_date = to_date.to_date - 5
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
    from_date = params[:from_date].presence || Date.today - 2
    to_date = params[:to_date].presence || Date.today
    if from_date.to_date > to_date.to_date
      from_date = to_date.to_date - 5
    end
    render :show, locals: { from_date: from_date,
                            to_date: to_date }
  end

  def user_report
    id = params[:id]
    @user = User.find(id)
    if @user.role == "clerk"
      @user = walk_in_customer
    end
    from_date = params[:from_date].presence || Date.today - 5
    to_date = params[:to_date].presence || Date.today
    if from_date.to_date > to_date.to_date
      from_date = to_date.to_date - 2
    end
    render :user_report, locals: { from_date: from_date,
                                   to_date: to_date,
                                   user: @user,
                                   locals: true }
  end

  def edit
    id = params[:id]
    user = User.find(id)
    user.name = params[:name]
    user.address = params[:address]
    user.save!
    flash[:notice] = "updated account details"
    redirect_to "/"
  end
end
