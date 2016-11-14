FactoryGirl.define do
  factory :reading_event do
    sensor_id { rand(1..4) }
    start_read { Faker::Number.number(3) }
    end_read { Faker::Number.number(3) }
    seconds_until_next_read { 0 }
  end
end
