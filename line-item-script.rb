# Set VAT equal to the amount of the VAT rate.
# For example, if the VAT rate is 20%, then VAT=20
VAT = 20

# Message that appears beside the discount in the checkout
VAT_REMOVAL_MESSAGE = "VAT removed"

# List of countries where the VAT is charged on orders
COUNTRY_CODES_EU = %w[
AT BE BG CY CZ DK EE FI FR DE GR HU IE IT
LV LT LU MT NL PL PT RO SK SI ES SE GB
]

if Input.cart.shipping_address
  unless COUNTRY_CODES_EU.include?(Input.cart.shipping_address.country_code)
    Input.cart.line_items.each do |line_item|
      product = line_item.variant.product
      next if product.gift_card?
      vat_only_fraction = VAT / (100.0 + VAT)
      vat =  line_item.line_price * vat_only_fraction
      ex_vat_price = line_item.line_price - vat
      line_item.change_line_price(ex_vat_price, message: VAT_REMOVAL_MESSAGE)
    end
  end
end

Output.cart = Input.cart
