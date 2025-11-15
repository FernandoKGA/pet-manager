class ExpensesController < ApplicationController
  before_action :authenticate_user

  def index
    @user = current_user
    @pets = current_user.pets
    @expenses = current_user.expenses.includes(:pet).order(date: :desc)

    # Lógica de filtro por pet e período (opcional, mas funcional)
    if params[:pet_id].present?
      @expenses = @expenses.where(pet_id: params[:pet_id])
    end

    if params[:period].present?
      case params[:period]
      when "Última semana"
        @expenses = @expenses.where("date >= ?", 1.week.ago.to_date)
      when "Último mês"
        @expenses = @expenses.where("date >= ?", 1.month.ago.to_date)
      when "Último ano"
        @expenses = @expenses.where("date >= ?", 1.year.ago.to_date)
      end
    end

    @chart_data = @expenses.reorder(nil).group(:category).sum(:amount)
  end

  def create
    @expense = current_user.expenses.build(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: 'Gasto registrado com sucesso'
    else
      redirect_to expenses_path, notice: 'Seu gasto não foi registrado. Verifique os dados e tente novamente.'
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :category, :description, :date, :pet_id)
  end
end
