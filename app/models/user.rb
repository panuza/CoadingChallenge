class User < ApplicationRecord
  has_secure_password
  has_many :challenges
  has_many :answers
end
