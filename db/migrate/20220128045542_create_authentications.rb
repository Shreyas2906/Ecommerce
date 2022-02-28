class CreateAuthentications < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.text :token
      t.datetime :token_expired_at

      t.timestamps
    end
  end
end
