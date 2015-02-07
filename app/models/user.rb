class User < ActiveRecord::Base
  has_many :comments
  has_many :attachments
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :question_answers, through: :questions, source: :answers
  has_many :authorizations
  has_and_belongs_to_many :subscriptions, class_name: 'Question', join_table: :subscriptions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if auth.provider == 'facebook'
      email = auth.info[:email] #if provider is facebook
    else
      email = "#{auth.info[:nickname]}@iknow.com"
    end
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def self.send_daily_digest
    find_each do |user|
      DailyMailer.delay.digest(user)
    end
  end

  def send_notification_about_answer(answer)
    UserMailer.delay.question_answered(self, answer)
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
