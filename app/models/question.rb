class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user
  validates :title, :body, :user_id, presence: true
end
