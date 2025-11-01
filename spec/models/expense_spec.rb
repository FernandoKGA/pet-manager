require "rails_helper"

RSpec.describe Expense, type: :model do
  it "is invalid without amount" do
    expense = Expense.new(date: Date.today, category: "food")
    expect(expense).not_to be_valid
    expect(expense.errors[:amount]).to include("can't be blank")
  end

end

