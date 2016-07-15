FactoryGirl.define do
  factory :user_notification do
    user factory: :user
    user factory: :notification
    opened { false }
  end
end
