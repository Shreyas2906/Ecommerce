class LikesController < ApplicationController
# 	before_action :find_product
# 	before_action :find_like, only: [:destroy]
#   def create
#   if already_liked?
#     flash[:notice] = "You can't like more than once"
#   else
#     @product.likes.create(user_id: current_user.id)
#   end
#   redirect_to product_path(@product)
# end

# def destroy
#   if !(already_liked?)
#     flash[:notice] = "Cannot unlike"
#   else
#     @like.destroy
#   end
#   redirect_to product_path(@product)
# end

# def find_like
#    @like = @product.likes.find(params[:id])
# end

#   private
#   def find_product
#     @product = Product.find(params[:product_id])
#   end


#   def already_liked?
#   Like.where(user_id: current_user.id, product_id:
#   params[:product_id]).exists?
# end

def index
  @likes = current_user.likes
end
end
