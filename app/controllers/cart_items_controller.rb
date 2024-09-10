class CartItemsController < ApplicationController
  before_action :set_cart, only: [:index, :destroy, :checkout, :checkout_razor, :cash_on_delivery]
  before_action :set_cart_item, only: :destroy

  def index
    unless current_user.cart.present?
      Cart.create(user_id: current_user.id)
    end

    @cart_items = @cart.cart_items
  end

  def show
    # Add implementation if needed
  end

  def destroy
    @cart.remove(@cart_item.item, 1)
    respond_to do |format|
      format.html { redirect_to cart_items_url, notice: 'Item was successfully removed from the cart.' }
      format.json { head :no_content }
    end
  end

  def checkout
    if params.dig("order", "cash_on_delivery").present?
      create_cash_on_delivery_order
    else
      create_stripe_checkout_session
    end
  end

  def checkout_razor
    if params.dig("order", "cash_on_delivery").present?
      create_cash_on_delivery_order
    else
      create_razorpay_payment_link
    end
  end

  def refund
    # Ensure payment ID and amount are correct
    create_razorpay_refund
  end

  def cart_items_razor_success
    handle_razorpay_success
  end

  def success
    handle_stripe_success
  end

  def cancel
    # Add implementation if needed
  end

  def cash_on_delivery
    create_cash_on_delivery_order
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:cart_item_id])
  end

  def create_cash_on_delivery_order
    order = OrderBooking.new(
      customer_email: current_user.email,
      customer_id: current_user.id,
      user_id: current_user.id,
      product_id: current_user.cart.cart_items.map(&:item_id),
      amount_total: current_user.cart.subtotal,
      address_id: params["order"]["address_id"],
      cash_on_delivery: true
    )
    order.save
    OrderStatus.create(order_id: order.id, status: "created")
    current_user.cart.clear
    redirect_to "/success"
  end

  def create_stripe_checkout_session
    Stripe.api_key = ENV["STRIPE_API_ID"]
    @session = Stripe::Checkout::Session.create(
      line_items: [{
        price_data: {
          currency: 'inr',
          product_data: {
            name: "Products in Cart",
          },
          unit_amount: (current_user.cart.subtotal.to_f * 100).to_i,
        },
        quantity: 1,
      }],
      phone_number_collection: { enabled: true },
      mode: 'payment',
      shipping_address_collection: { allowed_countries: ['IN'] },
      success_url: "http://localhost:3000/carts/success?session_id={CHECKOUT_SESSION_ID}&product_ids=#{current_user.cart.cart_items.map(&:item_id)}",
      cancel_url: 'http://localhost:3000/carts/cancel',
    )
    redirect_to @session.url, allow_other_host: true
  end

  def create_razorpay_payment_link
    require "uri"
    require "net/http"

    url = URI("https://api.razorpay.com/v1/payment_links")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Basic #{ENV['RAZORPAY_AUTHORIZATION_KEY']}"
    request.body = JSON.dump({
      "amount": current_user.cart.subtotal.to_i * 100,
      "currency": "INR",
      "accept_partial": true,
      "first_min_partial_amount": 100,
      "expire_by": (Time.now + 15.minutes).to_i,
      "reference_id": SecureRandom.hex(10),
      "notify": { "sms": true, "email": true },
      "reminder_enable": true,
      "notes": { "policy_name": "TEST" },
      "callback_url": "http://localhost:3000/cart_items_razor_success?product_ids=#{current_user.cart.cart_items.map(&:item_id)}&cart_id=#{current_user.cart.id}",
      "callback_method": "get"
    })
    @response = https.request(request)
    @sort_url = JSON.parse(@response.read_body)["short_url"]
    redirect_to @sort_url
  end

  def create_razorpay_refund
    require "uri"
    require "net/http"

    url = URI("https://api.razorpay.com/v1/payments/#{params[:payment_id]}/refund")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Basic #{ENV['RAZORPAY_AUTHORIZATION_KEY']}"
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({ amount: params[:amount] })

    response = https.request(request)
    puts response.read_body
  end

  def handle_razorpay_success
    require "uri"
    require "net/http"

    url = URI("https://api.razorpay.com/v1/payments/#{params[:razorpay_payment_id]}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Basic #{ENV['RAZORPAY_AUTHORIZATION_KEY']}"
    response = https.request(request)
    data = JSON.parse(response.body)

    order = OrderBooking.new(
      payment_intent: params[:razorpay_payment_id],
      amount_total: data["amount"] / 100,
      customer_id: current_user.id,
      user_id: current_user.id,
      customer_email: data["email"],
      order_id: data["order_id"],
      product_id: params[:product_ids]
    )
    order.save
    OrderStatus.create(order_id: order.id, status: "created")
    current_user.cart.clear
    redirect_to "/success"
  end

  def handle_stripe_success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    customer = Stripe::Customer.retrieve(session.customer)
    @cart_items = Product.where(id: params[:product_ids].split(/\D+/).reject(&:empty?).map(&:to_i))

    order = OrderBooking.new(
      customer_email: customer["email"],
      customer_id: customer["id"],
      product_id: params[:product_ids],
      customer_city: customer["address"]["city"],
      customer_country: customer["address"]["country"],
      customer_address_line_one: customer["address"]["line1"],
      customer_address_line_two: customer["address"]["line2"],
      post_code: customer["address"]["postal_code"],
      customer_state: customer["address"]["state"],
      customer_phone: customer["phone"],
      payment_intent: session["payment_intent"],
      amount_total: session["amount_total"],
      user_id: current_user.id
    )
    order.save
    OrderStatus.create(order_id: order.id, status: "created")
    current_user.cart.clear
    redirect_to "/success"
  end
end
