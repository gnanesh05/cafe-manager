class CustomersController < ApplicationController
  before_action :ensure_owner_logged_in

  def index
    @customers = User.customers
    @clerk = User.clerk
    render "index"
  end
end
