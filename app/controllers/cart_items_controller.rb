class CartItemsController < ApplicationController
	def index
    unless current_user.cart.present?
      Cart.create(user_id: current_user.id)
    end
    
    @cart = current_user.cart
		@cart_items = @cart.cart_items#current_user.cart.cart_items
	end
	respond_to do |format|
      format.html { redirect_to carts_url, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end

 def show
 	
 end

	def destroy
  @cart = current_user.cart
  @product = CartItem.find_by(id: params[:cart_item_id]).item
  @cart.remove(@product, 1)
  respond_to do |format|
    format.html { redirect_to cart_items_url }
    format.json { head :no_content }
  end
end

def checkout
  if params["order"]["cash_on_delivery"].present?
      @cart_items = Product.where(id: current_user.cart.cart_items.map(&:item_id))
      order = OrderBooking.new
      order.customer_email = current_user.email
      order.customer_id = current_user.id
      order.user_id = current_user.id
      order.product_id = current_user.cart.cart_items.map(&:item_id)
      order.amount_total = current_user.cart.subtotal
      order.address_id = params["order"]["address_id"]
      order.cash_on_delivery = true
      order.save
      OrderStatus.create(order_id: params[:order_id], status: "created")
      current_user.cart.clear
      redirect_to "/success"
    else  
    Stripe.api_key = "sk_test_51KJzIeSHDvKH3iF10nE5KxRQC29VqvcaOK0RcE8hLk69AygVBMF3L6QcQ9fy3HwOzndQIInOCN6iheJoIy7KEptf00pvuqYMHx"
    @session = Stripe::Checkout::Session.create({
      line_items: [{
        price_data: {
          currency: 'inr',
          product_data: {
            name: "#{current_user.cart.cart_items.map{|data| data.item.id}}",
          },
          
          unit_amount: (current_user.cart.subtotal.to_f*100.0).to_i,
        },
        quantity: 1,
      }],
      phone_number_collection: {
        enabled: true
      },
      mode: 'payment',
      shipping_address_collection: {
        allowed_countries: ['IN'],
      },
      # These placeholder URLs will be replaced in a following step.
      success_url: "http://localhost:3000/carts/success?session_id={CHECKOUT_SESSION_ID}&product_ids=#{current_user.cart.cart_items.map(&:item_id)}",
      cancel_url: 'http://localhost:3000/carts//cancel',
    })
   end
  end

  def checkout_razor
   require "uri"
    require "net/http"

    url = URI("https://api.razorpay.com/v1/payment_links")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Basic cnpwX3Rlc3RfNkhNVXdhZ2JRWTJzZUY6N1pkUTRkYk9SVW1DNnk5UEo0OE94clJ1"
    request.body = "{\n  \"amount\": 1000,\n  \"currency\": \"INR\",\n  \"accept_partial\": true,\n  \"first_min_partial_amount\": 100,\n  \"expire_by\": 1691097057,\n  \"reference_id\": \"@ran\",\n  \"description\": \"Payment for policy no #23456\",\n  \"customer\": {\n    \"name\": \"Gaurav Kumar\",\n    \"contact\": \"+919999999999\",\n    \"email\": \"gaurav.kumar@example.com\"\n  },\n  \"notify\": {\n    \"sms\": true,\n    \"email\": true\n  },\n  \"reminder_enable\": true,\n  \"notes\": {\n    \"policy_name\": \"Jeevan Bima\"\n  },\n  \"callback_url\": \"https://example-callback-url.com/\",\n  \"callback_method\": \"get\"\n}"
    byebug
    @response = https.request(request)
    @sort_url = JSON.parse(@response.read_body)["short_url"]

  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    customer = Stripe::Customer.retrieve(session.customer)
   @cart_items = Product.where(id: params[:product_ids].split(/\D+/).reject(&:empty?).map(&:to_i))
    
    order = OrderBooking.new
    order.customer_email = customer["email"]
    order.customer_id = customer["id"]
    order.product_id = params[:product_ids]
    order.customer_city = customer["address"]["city"]
    order.customer_country = customer["address"]["country"]
    order.customer_address_line_one =  customer["address"]["line1"]
    order.customer_address_line_two = customer["address"]["line2"]
    order.post_code = customer["address"]["postal_code"]
    order.customer_state = customer["address"]["state"]
    order.customer_phone = customer["customer_phone"]
    order.payment_intent = session["payment_intent"]
    order.amount_total = session["amount_total"]
    order.user_id = current_user.id
    order.save
    OrderStatus.create(order_id: order.id, status: "created")
    current_user.cart.clear
    redirect_to "/success"
  end

  def cancel
    byebug
   
  end

def total
  subtotals.sum
end

def cash_on_dilevery
  
end
  
end