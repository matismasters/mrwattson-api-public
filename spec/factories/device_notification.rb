FactoryGirl.define do
  factory :device_notification do
    user factory: :device
    user factory: :notification
    opened { false }
  end
end
