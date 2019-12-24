class User < ApplicationRecord
  has_secure_password
  has_many :challenges
  has_many :answers
  acts_as_voter
end
