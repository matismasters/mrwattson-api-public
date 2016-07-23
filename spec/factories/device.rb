FactoryGirl.define do
  factory :device do
    particle_id { Faker::Number.hexadecimal(10) }
    configuration { {} }
  end
end
