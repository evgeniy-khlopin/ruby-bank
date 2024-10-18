class UserSchema < ApplicationSchema
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
    required(:password_digest).filled(:string)
  end
end
