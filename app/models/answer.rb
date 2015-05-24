class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  after_create :send_notification

  def set_best
    question = Question.find(question_id)
    old_best = question.answers.find_by(best_answer: true)
    transaction do
      old_best.update!(best_answer:false) if old_best
      update!(best_answer: true)
      question.update!(resolved: true) unless question.resolved
    end
  end

  def send_notification
    NewAnswerWorker.perform_async(id)
  end
end
