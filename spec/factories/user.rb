FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Digest::MD5.digest Faker::Internet.password(8) }
  end
end
