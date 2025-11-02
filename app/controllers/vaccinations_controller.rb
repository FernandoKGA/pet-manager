class VaccinationsController < ApplicationController
  before_action :set_pet
  before_action :set_vaccination, only: [ :edit, :update, :destroy ]
  
  def index
    @vaccinations = @pet.vaccinations.order(applied_date: :desc)
  end

  def new
    @vaccination = @pet.vaccinations.new
  end

  def create
    @vaccination = @pet.vaccinations.new(vaccination_params)

    if @vaccination.save
      redirect_to pet_vaccinations_path(@pet), info: 'Vacinação cadastrada com sucesso.'
    else
      flash.now[:danger] = "Não foi possível salvar as informações de vacinação do pet."
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @vaccination.update(vaccination_params)
      redirect_to pet_vaccinations_path(@pet), info: 'Vacinação atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @vaccination.destroy

    redirect_to pet_vaccinations_path(@pet), info: 'Vacinação removida com sucesso.'
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:pet_id])
  end
 
  def set_vaccination
    if params[:pet_id]
      @pet = Pet.find(params[:pet_id])
      @vaccination = @pet.vaccinations.find(params[:id])
    else
      @vaccination = Vaccination.find(params[:id])
      @pet = @vaccination.pet
    end
  end

  def vaccination_params
    params.require(:vaccination).permit(:name, :applied_date, :applied, :applied_by)
  end
end
