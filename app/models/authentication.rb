class Authentication < ApplicationRecord
	belongs_to :user
 def self.from_omniauth(auth)
    authenticate = where(provider: auth['provider'], :uid=>auth['uid']).first_or_initialize
    register_user = User.find_by(email: auth.info.email)
    if authenticate.user
      return authenticate.user
    elsif register_user
      register_user.authentications.create(provider: auth['provider'], :uid=>auth['uid'])
      return register_user
    else
      user = User.new(
        email: auth.info.try(:email),                      
        password: Devise.friendly_token.first(8)
      )
      if user.email.blank?
        user.email=auth.extra.raw_info.id.to_s+"@gmail.com"
      end
      user.save!(:validate => false)
      user.authentications.create(provider: auth['provider'], :uid=>auth['uid'],token: auth["credentials"]["token"])
      return user
   end
  end
end
