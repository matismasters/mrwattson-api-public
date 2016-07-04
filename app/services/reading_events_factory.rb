class ReadingEventsFactory
  attr_reader :errors

  def initialize(device_id, particle_event_data)
    @device_id = device_id
    @particle_event_data = particle_event_data
    @errors = {}
  end

  def create_reading_events
    @created_reading_events = events_data.map do |event_data|
      reading_event = create_reading_event(event_data)

      add_error(
        event_data[:sensor_id],
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

  def create_reading_event(data)
    ReadingEvent.create(
      device_id: @device_id,
      sensor_id: data[:sensor_id],
      first_read: data[:first_read],
      second_read: data[:second_read]
    )
  end

  private

  def add_error(sensor_id, errors)
    @errors['sensor_id' + sensor_id] = errors
  end

  def events_data
    ReadingEventDataParamSplitter.new(@particle_event_data).process
  end
end
