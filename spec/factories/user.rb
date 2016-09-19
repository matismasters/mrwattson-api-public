FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'asdfasdf' }
    password_confirmation { 'asdfasdf' }
  end
end
