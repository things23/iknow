class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def question_answered(user, answer)
    @user = user
    @answer = answer

    mail to: @user.email, subject: 'Have answer to your question'
  end
end
