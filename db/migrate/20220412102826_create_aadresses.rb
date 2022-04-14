class CreateAadresses < ActiveRecord::Migration[6.0]
  def change
    create_table :aadresses do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :line1
      t.string :country
      t.string :state
      t.integer :pincode
      t.integer :user_id

      t.timestamps
    end
  end
end
