class NewAnswerWorker
  include Sidekiq::Worker


  def perform(answer_id)
    answer = Answer.find(answer_id)
    question = answer.question
    user = question.user
    subscribers = question.subscribers
    subscribers << user

    subscribers.each do |subscriber|
      subscriber.send_notification_about_answer(answer)
    end
  end
end