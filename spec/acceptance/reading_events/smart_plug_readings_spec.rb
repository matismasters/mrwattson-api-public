require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Device' do
  include DefaultHeaders

  parameter :device_ids, 'String::CSV list of device ids', required: true

  response_field :devices,
      'Array::Each item has the latest end_read of each device ' \
      'to each sensor, in that corresponding order. ' \
      'sensor_id: 1 => array[1], sensor_id: 2 => array[2], and so on. ' \
      'array[0] is always 0'

  after { Timecop.return }

  get 'devices/smart_plugs/:device_ids/reading_events/latest' do
    example 'Get latest reading events for several devices' do
      device_1 = create :device
      device_2 = create :device
      now = Time.now

      Timecop.freeze(now - 1.hours)
      create :reading_event,
        device_id: device_1.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1

      create :reading_event,
        device_id: device_2.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1

      Timecop.freeze(now)
      create :reading_event,
        device_id: device_1.id,
        start_read: 1000,
        end_read: 1000,
        sensor_id: 1

      create :reading_event,
        device_id: device_2.id,
        start_read: 1000,
        end_read: 999,
        sensor_id: 1

      do_request(device_ids: "#{device_1.id},#{device_2.id}")

      json_response = JSON.parse(response_body)
      devices = json_response['devices']
      device_1 = devices[0]
      device_2 = devices[1]

      expect(json_response).to be_a Hash
      expect(devices).to be_a Array
      expect(device_1[1]).to eq 1000
      expect(device_2[1]).to eq 999
    end
  end
end
