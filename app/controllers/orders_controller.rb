class OrdersController < ApplicationController
  def index
  end

  def cancel 
    
    #OrderStatus.create(order_id: params[:order_id], refund: "progress")

    order = OrderBooking.find_by(id: params[:order_id])
    Stripe.api_key = 'sk_test_51KJzIeSHDvKH3iF10nE5KxRQC29VqvcaOK0RcE8hLk69AygVBMF3L6QcQ9fy3HwOzndQIInOCN6iheJoIy7KEptf00pvuqYMHx'
    if order.cash_on_delivery == true
    else
    	byebug
     Stripe::Refund.create(payment_intent: order.payment_intent, amount: 10)
    end
    OrderStatus.create(order_id: params[:order_id], status: "cancelled")

    Stripe::Refund.create({ charge: 'ch_3KZ9XaSHDvKH3iF10VnL3tw1',})
    # redirect_to "/cancel"

    redirect_to orders_path
  end
end
