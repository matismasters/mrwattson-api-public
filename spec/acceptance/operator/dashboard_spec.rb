require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Operator' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  response_field :reads_total, 'Int::Current total consumption of all devices'

  get '/operator/last_read_from_all_devices' do
    example 'Get reads total' do
      device1 = create :device
      device2 = create :device
      device3 = create :device

      create :reading_event, device: device1, end_read: 100, sensor_id: 2
      create :reading_event, device: device1, end_read: 500, sensor_id: 1

      create :reading_event, device: device1, end_read: 100, sensor_id: 1
      create :reading_event, device: device2, end_read: 40, sensor_id: 1
      create :reading_event, device: device3, end_read: 10, sensor_id: 1

      do_request

      json_response = JSON.parse(response_body)
      reads = json_response['reads']

      expect(reads).to be_an(Array)
      expect(reads.size).to eq 3
      expect(reads[0]['end_read']).not_to be_nil
    end
  end
end
