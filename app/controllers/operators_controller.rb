class OperatorsController < ApplicationController
  def last_read_from_all_devices
    render json: { reads: ReadingEvent.last_read_from_all_devices }, status: 200
  end
end
