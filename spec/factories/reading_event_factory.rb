FactoryGirl.define do
  factory :reading_event do
    sensor_id { rand(0..3) }
    first_read { Faker::Number.number(3) }
    second_read { Faker::Number.number(3) }
  end
end
