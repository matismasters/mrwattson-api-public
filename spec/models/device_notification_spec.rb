require 'spec_helper'

describe 'DeviceNotification' do
  it 'Should save notification_type' do
    device_notification = create :device_notification
    device_notification.notification = create :report
    device_notification.device = create :device
    device_notification.save

    expect(device_notification.notification_type).to eq 'Report'
  end

  it 'Should set the Notification type to all existing notifications' do
    device_notification = create :device_notification
    notification = create :notification

    device_notification.notification = notification
    device_notification.device = create :device
    device_notification.save

    expect(device_notification.notification_type).to be_nil

    notification.type = 'Report'
    notification.save

    device_notification.update_notification_type
    device_notification.save

    expect(device_notification.notification_type).to eq 'Report'
  end
end
