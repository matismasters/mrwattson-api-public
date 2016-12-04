FactoryGirl.define do
  factory :notification do
    sql_query { 'select * from reading_events' }
    frequency { %w(daily weekly monthly)[rand(0..2)] }
    title { Faker::Lorem.sentence }
    body { "#{Faker::Lorem.paragraph} {{id}}" }
    tokens { 'id|start_read' }
    discovery { 'is {{start_read}}' }
    opportunity { '{{start_read}} is too much' }
    solution { 'change {{id}}' }

    trait :max_read_difference do
      sql_query do
        'SELECT device_id, MAX(read_difference) AS ' \
        'max_read_difference FROM reading_events GROUP BY device_id'
      end

      tokens { 'max_read_difference' }
      body { 'The max event diff is {{max_read_difference}}' }
    end

    factory :report, class: 'Report'
    factory :opportunity, class: 'Opportunity'
  end
end
