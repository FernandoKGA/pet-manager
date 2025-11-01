module BathsHelper
  def format_bath_price(price)
    number_to_currency(price, unit: "R$ ", separator: ",", delimiter: ".")
  end
end
