require 'spec_helper'

describe 'Create DeviceNotification when sending notifications' do
  let(:queue_manager) { class_double('NotificationSenderQueue') }

  describe 'when a notification is enqueued' do
    it 'should create the appropiate DeviceNotification' do
    end
  end
end
