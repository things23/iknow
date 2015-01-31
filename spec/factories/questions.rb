FactoryGirl.define do
  factory :question do
    title "MyQuestion"
    body "Body of my question"
    best_answer nil
    association :user

    factory :invalid_question, class: "Question" do
      title nil
      body nil
    end
  end
end
