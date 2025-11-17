# app/controllers/memorial_controller.rb
class MemorialController < ApplicationController
  before_action :authenticate_user
  
  def index
    @deceased_pets = current_user.pets.deceased.ordered_by_death_date
    @has_deceased_pets = @deceased_pets.any?
  end
end