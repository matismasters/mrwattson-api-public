namespace :process_and_send_notifications do
  desc 'Executes and sends all notificaitons'
  task all: :environment do
    NotificationsWorker.execute_notifications(NotificationSenderQueue)
  end
end
