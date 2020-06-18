class AboutController < ApplicationController
  skip_before_action :ensure_user_logged_in
  before_action :ensure_user_available

  def index
    render "about"
  end

  def ensure_user_available
    unless current_user
      render "index"
    end
  end
end
