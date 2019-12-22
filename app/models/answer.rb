class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  validates :answer, presence: true
end
