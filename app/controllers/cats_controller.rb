class CatsController < InheritedResources::Base

  private

    def cat_params
      params.require(:cat).permit(:title)
    end

end
