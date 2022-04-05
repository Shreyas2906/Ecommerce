class CreateOrderStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :order_statuses do |t|
      t.integer :order_id
      t.integer :status
      t.integer :refund

      t.timestamps
    end
  end
end
