# app/controllers/diary_entries_controller.rb
class DiaryEntriesController < ApplicationController
  before_action :set_pet
  before_action :set_diary_entry, only: [:destroy]

  def index
    @diary_entries = @pet.diary_entries.order(entry_date: :desc)

    # Lógica do filtro por data
    if params[:filter_date].present?
      selected_date = Date.parse(params[:filter_date])
      @diary_entries = @diary_entries.where(entry_date: selected_date.all_day)
    end
    
    @diary_entry = @pet.diary_entries.new
  end

  def create
    @diary_entry = @pet.diary_entries.new(diary_entry_params)

    if @diary_entry.save
      redirect_to pet_diary_entries_path(@pet), notice: 'Entrada do diário adicionada com sucesso!'
    else
      @diary_entries = @pet.diary_entries.order(entry_date: :desc)
      render :index, status: :unprocessable_content
    end
  end

  def destroy
    @diary_entry.destroy

    redirect_to pet_diary_entries_path(@pet), notice: 'Entrada do diário removida com sucesso.'
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_diary_entry
    @diary_entry = @pet.diary_entries.find(params[:id])
  end

  def diary_entry_params
    params.require(:diary_entry).permit(:content, :entry_date)
  end
end