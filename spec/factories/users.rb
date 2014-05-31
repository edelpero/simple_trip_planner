# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email    { Faker::Internet.email }
    username { Faker::Internet.user_name }
    name     { Faker::Name.name }
    password 'asdasdasd'
    password_confirmation 'asdasdasd'
  end
end
