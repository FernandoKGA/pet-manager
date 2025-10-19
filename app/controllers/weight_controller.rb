
class WeightController < ApplicationController
  before_action :set_pet

  def create
    @weight = @pet.weights.new(weight_params)

    if @weight.save
      redirect_to user_path(current_user), notice: 'Peso atualizado com sucesso.'
    else
      error_message = @weight.errors.full_messages.first
      redirect_to user_path(current_user), alert: error_message
    end
  end

  def new
    @weight = @pet.weights.new
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:pet_id])
  end

  def weight_params
    params.require(:weight).permit(:weight)
  end
end