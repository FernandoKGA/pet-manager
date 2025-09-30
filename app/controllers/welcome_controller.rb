class WelcomeController < ApplicationController
  skip_before_action :authenticate_user

  def index
    if current_user
      @pets = current_user.pets
    end
  end


end
