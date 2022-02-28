class ContactsController < ApplicationController
	def index
		@contact = Contact.new()
		
	end
	def create
		Contact.create(name: params[:form][:name], email: params[:form][:email], telephone: params[:form][:telephone], message: params[:form][:message])
	end
end