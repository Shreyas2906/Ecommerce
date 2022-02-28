class CreateSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_categories do |t|
      t.integer :category_id
      t.string :title

      t.timestamps
    end
  end
end
