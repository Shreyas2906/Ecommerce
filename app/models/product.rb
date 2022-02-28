class Product < ApplicationRecord
	belongs_to :sub_category
	has_many :likes, dependent: :destroy
	delegate :category, to: :sub_category
	mount_uploader :image, ImageUploader

end
