class NotificationSenderQueue
  def self.queue
    :notifications
  end

  def self.enqueue(device_id, title, body)
    Resque.enqueue(
      NotificationSenderQueue,
      'Slack',
      device_id: device_id,
      title: title,
      body: body
    )
  end

  # We have only one resque queue for notificaitons, and following
  # Resque conventions the Job perform method controls the execution
  # so this method can't avoid to smell like :reek:ControlParameter
  def self.perform(notification_method, data)
    case notification_method
    when 'Slack'
      SlackNotifications.send(data)
    end
  end
end
