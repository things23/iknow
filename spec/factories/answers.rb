FactoryGirl.define do
  factory :answer do
    body "MyText"
    best_answer false
    question
    user
    factory :invalid_answer, class: "Answer" do
      body nil
    end
  end
end
