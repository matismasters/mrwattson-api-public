class NotificationsWorker
  def self.execute_notifications(queue_manager)
    Device.all.each(&:clean_this_month_notifications!)

    Notification.to_run_now.each do |notification|
      notification.process_and_send(queue_manager)
    end
  end
end
