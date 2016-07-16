FactoryGirl.define do
  factory :device_notification do
    association :device, factory: :device
    association :notification, factory: :notification
    token_values { { 'sample' => '5' } }
    opened { false }
  end
end
