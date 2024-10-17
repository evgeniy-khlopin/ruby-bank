class UserSchema < ApplicationSchema
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
    required(:password_digest).filled(:string)
  end

  rule(:email) do
    key.failure('has already been taken') if User.exists?(email: value)
  end
end
