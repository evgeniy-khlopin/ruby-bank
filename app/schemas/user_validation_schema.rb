require 'dry-validation'

UserValidationSchema = Dry::Schema.Params do
  required(:first_name).filled(:string)
  required(:last_name).filled(:string)
  required(:email).filled(:string, format?: /\A[^@\s]+@[^@\s]+\z/)
end
