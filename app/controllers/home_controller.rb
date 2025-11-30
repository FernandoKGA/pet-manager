class HomeController < ApplicationController
  skip_before_action :authenticate_user
  def index
  end

  def about
  end

  def features
  end

  def contact
  end
end
