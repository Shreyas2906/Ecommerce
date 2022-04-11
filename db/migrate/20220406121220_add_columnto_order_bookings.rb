class AddColumntoOrderBookings < ActiveRecord::Migration[6.0]
  def change
  	add_column :order_bookings, :refund_id, :string
  end
end
