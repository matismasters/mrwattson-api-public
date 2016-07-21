require 'spec_helper'

describe 'Job runned by resque to send notifications' do
  describe '#perform' do
    let(:data) do
      {
        'device_id' => 1,
        'notification_id' => 1,
        'token_values' => {
          'token1' => 'value1',
          'token2' => 'value2'
        },
        'title' => 'This is the title',
        'body' => 'this is the value1 compared to value2'
      }
    end

    it 'should create a DeviceNotification' do
      # Prevent slack message trigger on tests
      allow(SlackNotifications).to receive(:send)

      NotificationSenderJob.perform('Slack', data)
      device_notification = DeviceNotification.first

      expect(device_notification.title).to eq data['title']
      expect(device_notification.body).to eq data['body']
      expect(device_notification.device_id).to eq data['device_id']
      expect(device_notification.notification_id).to eq data['notification_id']
      expect(device_notification.token_values).to eq data['token_values']
    end
  end
end
