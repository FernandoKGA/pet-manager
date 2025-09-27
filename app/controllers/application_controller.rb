class ApplicationController < ActionController::Base
  include SessionsHelper
  
  before_action :authenticate_user

  private
  def authenticate_user
    if !logged_in?
      redirect_to login_path, alert: "Por favor, faça login."
    end
  end
end
