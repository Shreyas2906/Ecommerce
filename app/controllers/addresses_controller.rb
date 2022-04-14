class AddressesController < ApplicationController

	def new
		byebug
	@address = Address.new	
	end

	def create
    @address = Address.new(address_params)
    respond_to do |format|
      if @address.save
        format.html { redirect_to address_url(@address), notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def product_params
      params.require(:product).permit(:email, :name, :line1, :state, :country, :phone, :pincode, :landmark)
    end
	
end