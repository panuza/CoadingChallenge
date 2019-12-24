class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  validates :answer, presence: true
  acts_as_votable
end
