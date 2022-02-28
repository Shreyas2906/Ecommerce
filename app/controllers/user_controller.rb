class UsersController < ApplicationController
  # ...
  def index
  	@user = User.new(user_params)
  end
  # POST /users or /users.json
  def create
        # Tell the UserMailer to send a welcome email after save
        UserMailer.with(user: @user).welcome_email.deliver_later

        
    end
  end

  # ...
end