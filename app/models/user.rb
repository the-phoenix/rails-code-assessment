class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 6 }, :if => :password
  validates :email, presence: true, uniqueness: true
end
