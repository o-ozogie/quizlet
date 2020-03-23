class User < ApplicationRecord
  has_many :question_sets, dependent: :delete_all
  has_many :scores, dependent: :delete_all
end
