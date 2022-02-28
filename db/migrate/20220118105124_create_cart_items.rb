class CreateCartItems < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_items do |t|

      t.timestamps
      t.shopping_cart_item_fields
    end
     # Creates the cart items fields
  end
end
