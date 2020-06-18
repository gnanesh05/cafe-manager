class AboutController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    render "about"
  end

end
