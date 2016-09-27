class ReadingEventsController < ApplicationController
  include FindDevice
  before_action :find_device_by_particle_id, only: :create

  def create
    factory = ReadingEventsCreator.new(
      @device,
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

  def permitted_params
    params.permit(:device_id, :data)
  end
end
