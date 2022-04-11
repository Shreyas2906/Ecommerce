class Cart < ApplicationRecord
	acts_as_shopping_cart_using :cart_item
	belongs_to :user
	def self.random
		"TSsd" + Random.rand(10000).to_s
	end
	
end
