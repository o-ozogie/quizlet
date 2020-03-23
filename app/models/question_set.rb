class QuestionSet < ApplicationRecord
  has_many :questions, dependent: :delete_all
  belongs_to :user
end
