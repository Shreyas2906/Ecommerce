class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|

      t.timestamps
      t.integer :user_id
    end
  end
end
