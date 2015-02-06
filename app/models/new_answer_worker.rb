class NewAnswerWorker
  include Sidekiq::Worker


  def perform(answer_id)
    #question = Question.find(question_id)
    #answer = question.answers.find(answer_id)
    answer = Answer.find(answer_id)
    user = answer.question.user

    #user.send_notification_about_answer(question, answer)
    user.send_notification_about_answer(answer)
  end
end