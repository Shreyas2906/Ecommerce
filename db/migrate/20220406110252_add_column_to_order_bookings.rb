class AddColumnToOrderBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :order_bookings, :order_id, :string
  end
end
