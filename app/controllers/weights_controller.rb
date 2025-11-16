class WeightsController < ApplicationController
  before_action :set_pet
  before_action :ensure_owner!, only: [:new, :create]

  def index
    @weights = @pet.weights.order(:created_at)
    @start_date = parse_date(params[:start_date])
    @end_date = parse_date(params[:end_date])

    if params[:start_date].present? && @start_date.nil?
      flash.now[:alert] = 'Data inicial inválida. Use o formato dd/mm/aaaa.'
    elsif params[:end_date].present? && @end_date.nil?
      flash.now[:alert] = 'Data final inválida. Use o formato dd/mm/aaaa.'
    elsif @start_date && @end_date && @start_date > @end_date
      flash.now[:alert] = 'A data inicial não pode ser posterior à final.'
      @start_date = @end_date = nil
    else
      @weights = @weights.where('created_at >= ?', @start_date.beginning_of_day) if @start_date
      @weights = @weights.where('created_at <= ?', @end_date.end_of_day) if @end_date
    end

    @chart_data = @pet.weight_chart_points(@weights)

    respond_to do |format|
      format.html
      format.json { render json: { data: @chart_data } }
    end
  end

  def new
    @weight = @pet.weights.new
  end

  def create
    @weight = @pet.weights.new(weight_params)

    if @weight.save
      redirect_to pet_weights_path(@pet), notice: 'Peso atualizado com sucesso.'
    else
      error_message = @weight.errors.full_messages.first
      redirect_to pet_weights_path(@pet), alert: error_message
    end
  end

  private

  def set_pet
    @pet = if current_user.respond_to?(:veterinarian?) && current_user.veterinarian?
             Pet.find(params[:pet_id])
           else
             current_user.pets.find(params[:pet_id])
           end
  end

  def ensure_owner!
    return if @pet.user_id == current_user.id

    redirect_to pet_weights_path(@pet), alert: 'Somente o tutor pode registrar novos pesos.'
  end

  def weight_params
    params.require(:weight).permit(:weight)
  end

  def parse_date(raw_value)
    return if raw_value.blank?

    Date.parse(raw_value)
  rescue ArgumentError
    nil
  end
end
