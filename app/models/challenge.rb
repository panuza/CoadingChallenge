class Challenge < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :name, :question, :category, :difficulty_level, presence: true
end
