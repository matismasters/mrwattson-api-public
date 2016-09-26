FactoryGirl.define do
  factory :user_device do
    association :user, factory: :user
    association :device, factory: :device
  end
end
