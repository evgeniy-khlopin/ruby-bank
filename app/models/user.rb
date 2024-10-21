# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string           not null
#
class User < ApplicationRecord
  has_secure_password

  has_many :bank_accounts, dependent: :destroy
  has_many :bank_transactions, through: :bank_accounts

  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
