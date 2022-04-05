class Cart < ApplicationRecord
	acts_as_shopping_cart_using :cart_item
	belongs_to :user
	ran = Random.rand(10000000).to_sType a message
end
