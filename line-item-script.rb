COUNTRY_CODES_EU = %w[
  AT BE BG CY CZ DK EE FI FR DE GR HU IE IT
  LV LT LU MT NL PL PT RO SK SI ES SE GB
]

Input.cart.line_items.each do |line_item|
  product = line_item.variant.product
  next if product.gift_card?
  next if Input.cart.shipping_address and COUNTRY_CODES_EU.include?(Input.cart.shipping_address.country_code)
  vat_only_fraction = 20 / 120.0
  vat =  line_item.line_price * vat_only_fraction
  ex_vat_price = line_item.line_price - vat
  line_item.change_line_price(ex_vat_price, message: "VAT removed")
end

Output.cart = Input.cart