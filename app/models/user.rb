class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :cart
  has_many :wishlists
  has_many :likes, dependent: :destroy

  has_many :authentications, dependent: :destroy
	validates :email, :uniqueness => {:allow_blank => true}

	has_many :addresses
	has_many :order_bookings

end
