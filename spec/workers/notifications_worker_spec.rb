require 'spec_helper'

describe 'Notifications Worker process' do
  let(:queue_manager) { double('NotificationSenderJob') }

  before do
    @device = create :device
    create_list :reading_event, 10, device: @device
    @daily = create :notification, :max_read_difference, frequency: 'daily'
    @weekly = create :notification, :max_read_difference, frequency: 'weekly'
    @monthly = create :notification, :max_read_difference, frequency: 'monthly'
  end

  describe 'All notifications behaviour when starting with last run null' do
    it 'first run should execute all notifications' do
      expect(queue_manager).to receive(:enqueue).exactly(3)

      NotificationsWorker.execute_notifications(queue_manager)

      expect(Notification.where(last_run: nil).count).to eq 0
    end

    it 'second run not execute any notifications' do
      expect(queue_manager).to receive(:enqueue).exactly(3)

      expect(Notification.to_run_now.count).to eq 3
      NotificationsWorker.execute_notifications(queue_manager)
      expect(Notification.to_run_now.count).to eq 0
    end
  end

  describe 'Daily Notifications should run only once every 24 hours' do
    after do
      Timecop.return
    end

    it 'should enqueue 3 when last_run null, 0 after 23 hours, ' \
       '1 more after 25 hours (daily) total 4 enqueues' do
      expect(queue_manager).to receive(:enqueue).exactly(4)

      Timecop.freeze

      expect(Notification.to_run_now.count).to eq 3
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 23.hours)

      expect(Notification.to_run_now.count).to eq 0
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 25.hours)

      expect(Notification.to_run_now.count).to eq 1
      NotificationsWorker.execute_notifications(queue_manager)
    end

    it 'should enqueue 3 when last_run null, 1 after 3 days(daily), ' \
       '2 more after 7 days(daily and weekly) total 6 enqueues' do
      expect(queue_manager).to receive(:enqueue).exactly(6)

      Timecop.freeze

      expect(Notification.to_run_now.count).to eq 3
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 3.days)

      expect(Notification.to_run_now.count).to eq 1
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 7.days)

      expect(Notification.to_run_now.count).to eq 2
      NotificationsWorker.execute_notifications(queue_manager)
    end

    it 'should enqueue 3 when last_run null, 2 after 15 days ' \
       '(daily and weekly), 3 more after 30 days (daily, weekly, and monthly) '\
       'total 8 enqueues' do
      expect(queue_manager).to receive(:enqueue).exactly(8)

      Timecop.freeze

      expect(Notification.to_run_now.count).to eq 3
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 15.days)

      expect(Notification.to_run_now.count).to eq 2
      NotificationsWorker.execute_notifications(queue_manager)

      Timecop.freeze(Time.now + 30.days)

      expect(Notification.to_run_now.count).to eq 3
      NotificationsWorker.execute_notifications(queue_manager)
    end
  end
end
