class DevicesController < ApplicationController
  include FindDevice

  before_action :find_device, only: :notifications

  def notifications
    render(
      json: @device.device_notifications.order('created_at desc'),
      status: 200
    )
  end
end
