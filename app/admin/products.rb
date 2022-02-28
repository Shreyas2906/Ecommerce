ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :title, :description, :price, :image, :size, :sub_category_id


   form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :image
      f.input :price
      f.input :size
      f.input :sub_category_id, as: :select, collection: option_groups_from_collection_for_select(Category.all, :sub_categories, :title, :id, :title, resource.sub_category_id)
    end
    f.actions 
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :price, :image, :size, :sub_category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
