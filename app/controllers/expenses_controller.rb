class ExpensesController < ApplicationController
  before_action :authenticate_user

  def index
    @expenses = current_user.expenses.includes(:pet)
    @pets = current_user.pets
  end

  def new
    @expense = Expense.new
    @pets = current_user.pets
  end

  def create
    @expense = current_user.expenses.build(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: 'Gasto registrado com sucesso'
    else
      @pets = current_user.pets
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :category, :description, :date, :pet_id)
  end
end
