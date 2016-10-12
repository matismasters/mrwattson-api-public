require 'spec_helper'

describe 'Complex Queries service', type: :unit do
  after do
    Timecop.return
  end

  describe 'yesterday_spendings' do
    it 'should return $120 for a day with 24 kw/h' do
      device = create :device
      now = Time.now

      Timecop.freeze(now - 2.day) # Should not count
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 86400

      Timecop.freeze(now - 1.day)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 86400

      Timecop.freeze(now)

      result = ComplexQueries.yesterday_spendings(device.id).first

      expect(result['daily_spendings']).to eq "120"
    end
  end

  describe 'latest_3_hours_spending' do
    it 'should return $5 for each hour on 1 kw/h spent' do
      device = create :device
      now = Time.now

      Timecop.freeze(now - 4.hours) # should not count
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now - 3.hours)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now - 2.hours)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now - 1.hours)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now) # Because we are using NOW() from DATABASE

      result = ComplexQueries.latest_3_hours_spendings(device.id)

      expect(result[0]['hourly_spendings']).to eq '5'
      expect(result[1]['hourly_spendings']).to eq '5'
      expect(result[2]['hourly_spendings']).to eq '5'
    end
  end
end
