class ReadingEventDataParamSplitter
  def initialize(param)
    @param = param
  end

  def process
    raise ArgumentError, 'event data format is invalid' unless validate_format

    @data ||= events_data.map do |event_data|
      {
        sensor_id: event_data[0],
        start_read: event_data[1],
        end_read: event_data[2]
      }
    end
  end

  def validate_format
    events_data.each { |data| return false if data.size != 3 }
    true
  end

  def events_data
    @events_data ||= @param.split('-').map { |data| data.split('|') }
  end
end
