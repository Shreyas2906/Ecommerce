class AadressesController < InheritedResources::Base

  private

    def aadress_params
      params.require(:aadress).permit(:email, :name, :phone, :line1, :country, :state, :pincode, :user_id)
    end

end
