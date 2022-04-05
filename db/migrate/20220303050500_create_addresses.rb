class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.text :line1
      t.string :pincode
      t.text :landmark
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
