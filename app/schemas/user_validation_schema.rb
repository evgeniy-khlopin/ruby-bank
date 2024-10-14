require 'dry-validation'

class UserValidationSchema < Dry::Validation::Contract
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    required(:email).filled(:string, format?: /\A[^@\s]+@[^@\s]+\z/)
  end
end
