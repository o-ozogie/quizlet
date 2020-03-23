class Question < ApplicationRecord
  has_many :scores, dependent: :delete_all
  belongs_to :question_set
end
