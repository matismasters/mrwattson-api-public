class ReadingEventsCreator
  attr_reader :errors

  def initialize(device_id, particle_event_data)
    @device_id = device_id
    @particle_event_data = particle_event_data
    @errors = {}
  end

  def create_reading_events
    @created_reading_events = events_data.map do |data|
      reading_event = ReadingEvent.create(data.merge({ device_id: @device_id }))

      add_error(
        data[:sensor_id],
        reading_event.errors
      ) unless reading_event.valid?

      reading_event
    end
  end

  def no_errors?
    @errors.empty?
  end

  def created_reading_events
    @created_reading_events.select(&:valid?)
  end

  private

  def add_error(sensor_id, errors)
    @errors['sensor_id' + sensor_id] = errors
  end

  def events_data
    ReadingEventDataParamSplitter.new(@particle_event_data).process
  end
end
