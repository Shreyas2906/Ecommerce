class CreateOrderBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :order_bookings do |t|
      t.string :customer_email
      t.string :customer_id
      t.string :customer_city
      t.string :customer_country
      t.string :customer_address_line_one
      t.string :customer_address_line_two
      t.integer :post_code
      t.string :customer_state
      t.integer :customer_phone
      t.string :payment_intent
      t.decimal :amount_total
      t.string :product_id, default: [], array: true
      t.integer :user_id

      t.timestamps
    end
  end
end
