class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  after_create :send_notification

  def set_best
    @id = self.question_id
    question = Question.where(id: @id).first
    #existed_best = Answer.where(question_id: question.id, best_answer: true).first
    existed_best = question.answers.find_by(best_answer: true)

    if existed_best
      existed_best.update_attributes(best_answer: false)
    end

    update_columns(best_answer: true)
  end

  def send_notification
    NewAnswerWorker.perform_async(id)
  end
end
