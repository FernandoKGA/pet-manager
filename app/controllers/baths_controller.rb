class BathsController < ApplicationController
  before_action :set_pet, only: [:index, :new, :create]
  before_action :set_bath, only: %i[ show edit update destroy ]
  #before_action :set_bath, only: [:show, :edit, :update, :destroy]

# GET /pets/:pet_id/baths
  def index
    # Lista apenas os banhos do pet atual
    @baths = @pet.baths.order(date: :desc)
  end

  # GET /baths/1
  def show
    # @bath já foi carregado por set_bath
  end

  # GET /pets/:pet_id/baths/new
  def new
    # Cria um novo banho associado ao pet
    @bath = @pet.baths.new
  end

 # POST /pets/:pet_id/baths
  def create
    @bath = @pet.baths.new(bath_params)

    if @bath.save
      redirect_to pet_baths_path(@pet), notice: 'Banho cadastrado com sucesso.'
    else
      flash.now[:alert] = "Não foi possível salvar as informações do banho do pet."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /baths/1/edit
  def edit
  end

  # PATCH/PUT /baths/1
  def update
    if @bath.update(bath_params)
      redirect_to @bath, notice: 'Banho atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /baths/1
  def destroy
    @bath.destroy
    redirect_to pet_baths_url(@bath.pet_id), notice: 'Banho excluído.'
  end

  private
    # Define o pet pai
    def set_pet
      @pet = Pet.find(params[:pet_id])
    end

   # Define o banho
    def set_bath
      # Se a rota é aninhada, fazemos Pet.find.baths.find. Se não, apenas Bath.find
      if params[:pet_id]
        @pet = Pet.find(params[:pet_id])
        @bath = @pet.baths.find(params[:id])
      else
        @bath = Bath.find(params[:id])
        @pet = @bath.pet # Para ter o pet disponível para redirecionamentos
      end
    end

    # Strong Parameters
    def bath_params
      params.require(:bath).permit(:date, :price, :notes)
    end
end