class DevicesController < ApplicationController
  include FindDevice

  before_action :find_device, only: [:notifications, :latest]

  def notifications
    render(
      json: @device.device_notifications.order('created_at desc'),
      status: 200
    )
  end

  def latest
    render json: @device.sensors_last_reads, status: 200
  end
end
