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
      device1 = create :device
      device2 = create :device
      now = Time.now

      Timecop.freeze(now - 1.hours)
      create :reading_event,
        device_id: device1.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1

      create :reading_event,
        device_id: device2.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1

      Timecop.freeze(now)
      create :reading_event,
        device_id: device1.id,
        start_read: 1000,
        end_read: 1000,
        sensor_id: 1

      create :reading_event,
        device_id: device2.id,
        start_read: 1000,
        end_read: 999,
        sensor_id: 1

      do_request(device_ids: "#{device1.id},#{device2.id}")

      json_response = JSON.parse(response_body)
      devices = json_response['devices']
      device1 = devices[0]
      device2 = devices[1]

      expect(json_response).to be_a Hash
      expect(devices).to be_a Array
      expect(device1[1]).to eq 1000
      expect(device2[1]).to eq 999
    end
  end
end
