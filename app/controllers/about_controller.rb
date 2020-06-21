class AboutController < ApplicationController
  skip_before_action :ensure_user_logged_in
  before_action :current_user

  def index
    render "about"
  end
end
