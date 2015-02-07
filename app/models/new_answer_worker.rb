class NewAnswerWorker
  include Sidekiq::Worker


  def perform(answer_id)
    #question = Question.find(question_id)
    #answer = question.answers.find(answer_id)
    answer = Answer.find(answer_id)
    question = answer.question
    user = question.user
    subscribers = question.subscribers
    subscribers << user

    #user.send_notification_about_answer(answer)
    subscribers.each do |subscriber|
      subscriber.send_notification_about_answer(answer)
    end
  end
end