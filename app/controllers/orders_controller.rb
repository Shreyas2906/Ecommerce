class OrdersController < ApplicationController
  def index
  end

  def cancel 
    
    #OrderStatus.create(order_id: params[:order_id], refund: "progress")

    # order = OrderBooking.find_by(id: params[:order_id])
    # Stripe.api_key = 'sk_test_51KJzIeSHDvKH3iF10nE5KxRQC29VqvcaOK0RcE8hLk69AygVBMF3L6QcQ9fy3HwOzndQIInOCN6iheJoIy7KEptf00pvuqYMHx'
    # if order.cash_on_delivery == true
    # else
    #  Stripe::Refund.create(payment_intent: order.payment_intent, amount: 10)
    # end
    # OrderStatus.create(order_id: params[:order_id], status: "cancelled")

    # Stripe::Refund.create({ charge: 'ch_3KZ9XaSHDvKH3iF10VnL3tw1',})
    # # redirect_to "/cancel"
     # JSON.parse(response.read_body)["amount"]

    order = OrderBooking.find_by(id: params[:order_id])
    if order.order_id.present?
      require "uri"
      require "net/http"

      url = URI("https://api.razorpay.com/v1/payments/#{order.payment_intent}/refund")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Authorization"] = "Basic cnpwX3Rlc3RfNkhNVXdhZ2JRWTJzZUY6N1pkUTRkYk9SVW1DNnk5UEo0OE94clJ1"
      request["Content-Type"] = "application/json"
      request.body = "{  \n\"amount\": order.amount_total.to_i-10}"
      response = https.request(request)
      puts response.read_body
      OrderStatus.create(order_id: params[:order_id], status: "cancelled" )
      order.update(refund_id:  params[:id])
    else
    OrderStatus.create(order_id: params[:order_id], status: "cancelled")
    end
    redirect_to orders_path
  end
end
