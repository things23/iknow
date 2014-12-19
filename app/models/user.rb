class User < ActiveRecord::Base
  has_many :comments
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
