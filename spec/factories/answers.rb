FactoryGirl.define do
  factory :answer do
    body "MyText"
    association :question

    factory :invalid_answer, class: "Answer" do
      body nil
    end
  end
end
