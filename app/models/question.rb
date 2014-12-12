class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user
  validates :title, :body, presence: true
end
