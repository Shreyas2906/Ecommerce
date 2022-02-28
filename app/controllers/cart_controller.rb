class CartController < ApplicationController
	before_action :set_cart, only: %i[ show edit update destroy ]

	def index
    @carts = Cart.all
  end

	def create
    #@cart = Cart.new(cart_params)
    	@cart = Cart.create
    	@product = Product.find(params[:product_id])
     	@cart.add_product(@product)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to cart_item_url(@cart), notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.clear

    respond_to do |format|
      format.html { redirect_to carts_url, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:cart, {})
    end
  
end