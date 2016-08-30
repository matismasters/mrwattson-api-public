require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Operator' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  response_field :reads_total, 'Int::Current total consumption of all devices'

  get '/operator/reads_total' do
    example 'Get reads total' do
      device_1 = create :device
      device_2 = create :device
      device_3 = create :device

      create :reading_event, device: device_1, end_read: 100, sensor_id: 2
      create :reading_event, device: device_1, end_read: 500, sensor_id: 1

      create :reading_event, device: device_1, end_read: 100, sensor_id: 1
      create :reading_event, device: device_2, end_read: 40, sensor_id: 1
      create :reading_event, device: device_3, end_read: 10, sensor_id: 1

      do_request

      json_response = JSON.parse(response_body)

      expect(json_response['reads_total']).not_to be_nil
      expect(json_response['reads_total']).to eq 150
    end
  end
end
