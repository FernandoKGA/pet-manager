require 'rails_helper'

# Este describe testa o BathsHelper
RSpec.describe BathsHelper, type: :helper do
  describe "#format_bath_price" do
    it "formata o preço para o padrão brasileiro com R$" do
      price = 9.99
      # Chama o método do helper (que é injetado no contexto 'helper')
      expect(helper.format_bath_price(price)).to eq("R$ 9,99")
    end
  end
end
