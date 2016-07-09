class Notification < ActiveRecord::Base
  # TODO: Implement synchronization with week start and end, as well
  # as month start and end
  scope :to_run_now, proc {
    where(
      'last_run IS NULL OR ' \
      "(frequency like 'daily' AND last_run <= ?) OR " \
      "(frequency like 'weekly' AND last_run <= ?) OR " \
      "(frequency like 'monthly' AND last_run <= ?)",
      Time.now - 1.day,
      Time.now - 7.days,
      Time.now - 30.days
    )
  }

  def process_and_send(queue_manager)
    CustomQuery.new(sql_query).execute.each do |row|
      queue_manager.enqueue(
        row['device_id'].to_i,
        title,
        TokenBasedInterpolations.interpolate(
          build_token_replacements(row),
          body
        )
      )
    end && update_last_run
  end

  def build_token_replacements(row)
    tokens.split('|').map do |token|
      { token => row[token] }
    end.reduce({}, :merge)
  end

  private

  def update_last_run
    update_attribute(:last_run, Time.now)
  end
end
