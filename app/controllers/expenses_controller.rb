class ExpensesController < ApplicationController
  before_action :authenticate_user
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :set_form_dependencies, only: [:index, :create, :edit, :update]

  def index
    prepare_dashboard
    ensure_expense_form_object
  end

  def create
    @expense = current_user.expenses.build(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: 'Gasto registrado com sucesso'
    else
      prepare_dashboard
      ensure_expense_form_object
      open_modal!
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    prepare_dashboard
    ensure_expense_form_object
    open_modal!
    render :index
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: 'Gasto atualizado com sucesso'
    else
      prepare_dashboard
      open_modal!
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: 'Gasto excluído com sucesso'
  end

  private

  def set_form_dependencies
    @user = current_user
    @pets = current_user.pets.active
  end

  def prepare_dashboard
    @expenses = filtered_expenses
    @chart_data = @expenses.reorder(nil).group(:category).sum(:amount)
  end

  def ensure_expense_form_object
    @expense ||= current_user.expenses.build
  end

  def open_modal!
    @open_modal = true
  end

  def filtered_expenses
    expenses = current_user.expenses.includes(:pet).order(date: :desc)

    if params[:pet_id].present?
      expenses = expenses.where(pet_id: params[:pet_id])
    end

    if params[:period].present?
      case params[:period]
      when "Última semana"
        expenses = expenses.where("date >= ?", 1.week.ago.to_date)
      when "Último mês"
        expenses = expenses.where("date >= ?", 1.month.ago.to_date)
      when "Último ano"
        expenses = expenses.where("date >= ?", 1.year.ago.to_date)
      end
    end

    expenses
  end

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:amount, :category, :description, :date, :pet_id)
  end
end
