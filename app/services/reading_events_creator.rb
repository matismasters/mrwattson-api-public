class ReadingEventsCreator
  attr_reader :errors

  def initialize(device, particle_event_data)
    @device = device
    @particle_event_data = particle_event_data
    @errors = {}
  end

  def create_reading_events
    @created_reading_events = events_data.map do |data|
      reading_event = ReadingEvent.new(data)
      reading_event.device = @device
      reading_event.save

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

  def set_last_reading_events_for_device
    created_reading_events.each do |reading_event|
      @device.send(
        :"last_reading_event_for_sensor_#{reading_event.sensor_id}=",
        reading_event.id
      )
    end

    @device.save
  end

  def events_data
    ReadingEventDataParamSplitter.new(@particle_event_data).process
  end
end
