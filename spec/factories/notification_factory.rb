FactoryGirl.define do
  factory :notification do
    sql_query { 'select * from reading_events' }
    frequency { %w(daily weekly monthly)[rand(0..2)] }
    title { Faker::Lorem.sentence }
    body { "#{Faker::Lorem.paragraph} {{id}}" }
    tokens { 'id|start_read' }
  end
end
