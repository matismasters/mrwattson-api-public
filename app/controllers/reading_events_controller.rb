class ReadingEventsController < ApplicationController
  before_action :find_device, only: [:create, :latest]

  def index
    events = ReadingEvent.all_readings_from_last_7_days

    render json: events, status: 200
  end

  def latest
    sensors_last_reads = @device.sensors_last_reads

    render json: sensors_last_reads, status: 200
  end

  def create
    factory = ReadingEventsCreator.new(
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
