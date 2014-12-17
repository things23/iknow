FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.ru"
  end
  factory :user do
    email
    password "123123123"
    password_confirmation  "123123123"
  end
end
