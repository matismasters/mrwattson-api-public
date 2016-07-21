class NotificationSenderJob
  def self.queue
    :notifications
  end

  def self.enqueue(data)
    Resque.enqueue(NotificationSenderJob, 'Slack', data)
  end

  # We have only one resque queue for notificaitons, and following
  # Resque conventions the Job perform method controls the execution
  # so this method can't avoid to smell like :reek:ControlParameter
  def self.perform(notification_methods, data)
    notification_methods.split('|').each do |notification_method|
      case notification_method
      when 'Slack' then SlackNotifications.send(data)
      end

      DeviceNotification.create(
        device_id: data['device_id'],
        notification_id: data['notification_id'],
        token_values: data['token_values'],
        title: data['title'],
        body: data['body']
      )
    end
  end
end
