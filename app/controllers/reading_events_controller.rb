class ReadingEventsController < ApplicationController
  before_action :find_device, only: :create

  def index
    render json: ReadingEvent.all, status: 200
  end

  def create
    @reading_event =
      ReadingEvent.create(reading_event_params.except(:device_id))

    @reading_event.device = @device

    if @reading_event.save
      render json: @reading_event, status: 201
    else
      render json: @reading_event.errors, status: 422
    end
  end

  private

  def find_device
    @device = Device.find_by_particle_id(params[:device_id])

    render json: { device_id: 'not found' }, status: 404 unless @device.present?
  end

  def reading_event_params
    params.permit(:device_id, :sensor_id, :first_read, :second_read)
  end
end
