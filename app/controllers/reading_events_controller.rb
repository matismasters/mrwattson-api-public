class ReadingEventsController < ApplicationController
  before_action :find_device, only: [:create, :latest]

  def index
    events = ReadingEvent
      .where('created_at >= ?', Time.now - 7.days)
      .order(:created_at)

    render json: events, status: 200
  end

  def latest
    reading_event = @device.reading_events.order('created_at desc').limit(1)[0]

    if reading_event
      render json: reading_event, status: 200
    else
      render json: { device: "doesn't have readings yet" }, status: 200
    end
  end

  def create
    factory = ReadingEventsFactory.new(
      @device.id,
      permitted_params.require(:data)
    )
    factory.create_reading_events

    if factory.no_errors?
      render json: factory.created_reading_events, status: 201
    else
      render json: factory.errors, status: 422
    end
  end

  private

  def find_device
    @device = Device.find_by_particle_id(permitted_params.require(:device_id))

    render json: { device_id: 'not found' }, status: 404 unless @device.present?
  end

  def permitted_params
    params.permit(:device_id, :data)
  end
end
