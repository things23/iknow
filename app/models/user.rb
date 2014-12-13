class User < ActiveRecord::Base
  has_many :questions,dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
