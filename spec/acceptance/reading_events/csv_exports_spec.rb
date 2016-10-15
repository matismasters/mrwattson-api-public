require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  include DefaultHeaders

  parameter :device_id, 'String::Particle deviceId', required: true
  parameter :sensor_id, 'Integer::1-4, sensor id', required: true
  parameter :start_date, 'String::YYYY-MM-DD-HH-mm', required: true
  parameter :end_date, 'String::YYYY-MM-DD-HH-mm', required: true

  response_field :csv,
    'CSV::The response will be a CSV with all fields of the corresponding ' \
    'Reading Events'

  response_field :'*first_row',
    'Will contain the spending calculation in pesos'

  after { Timecop.return }

  get '/reading_events/:device_id/report/:sensor_id/:start_date/:end_date' do
    example 'Get report of Reading Events between dates for specified device and sensor' do
      device = create :device
      now = Time.now

      Timecop.freeze(now - 3.hours)
      a = create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1

      Timecop.freeze(now - 2.hours)
      puts now - 2.hours
      b = create :reading_event,
        device_id: device.id,
        start_read: 1000,
        end_read: 0,
        sensor_id: 1

      start_date = ((now - 4.hours).utc).strftime('%Y-%m-%d-%H-%M')
      end_date = ((now - 1.hours).utc).strftime('%Y-%m-%d-%H-%M')

      Timecop.freeze(now)

      do_request(
        device_id: device.particle_id,
        sensor_id: 1,
        start_date: start_date,
        end_date: end_date
      )

      csv_parse = CSV.parse(response_body)

      expect(csv_parse.size).to eq 3
    end
  end
end
