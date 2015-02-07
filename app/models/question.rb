class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_and_belongs_to_many :subscribers, class_name: 'User', join_table: :subscriptions
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  scope :asked_today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  def subscribe(user)
    subscribers << user
  end

  def subscriber?(user)
   #subscribers.each do |subscriber|
   #   if subscriber == user
   #     return true
   #   else
   #     false
   #   end
   # end
   subscribers.exists? user
  end
end
