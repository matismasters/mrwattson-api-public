class NotificationsWorker
  def self.execute_notifications(queue_manager)
    Notification.to_run_now.each do |notification|
      notification.process_and_send(queue_manager)
    end
  end
end
