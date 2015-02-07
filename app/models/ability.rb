class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
     can :manage, :all
     cannot :mark_best_answer, Answer do |answer|
      answer.question.user != user
    end
  end

  def user_abilities
    guest_abilities
    can :subscribe, Question
    can :create, [Question, Answer, Comment]
    can [:update,:destroy], [Question, Answer, Comment], user: user
    can :mark_best_answer, Answer do |answer|
      answer.question.user == user
    end
  end
end
