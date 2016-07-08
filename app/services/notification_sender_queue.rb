class NotificationSenderQueue
  def self.enqueue(device_id, title, body)
    [device_id, title, body]
  end
end
