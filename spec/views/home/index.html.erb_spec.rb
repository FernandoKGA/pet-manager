require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  #pending "add some examples to (or delete) #{__FILE__}"
    it "exibe a mensagem de boas-vindas" do
    render
    expect(rendered).to include("Bem-vindo à Pet Manager!")
  end
end
