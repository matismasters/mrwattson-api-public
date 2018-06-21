class Notification < ActiveRecord::Base
  # TODO: Implement synchronization with week start and end, as well
  # as month start and end
  scope :to_run_now, proc {
    where(
      'last_run IS NULL OR ' \
      "(frequency like 'daily' AND last_run <= ?) OR " \
      "(frequency like 'weekly' AND last_run <= ?) OR " \
      "(frequency like 'monthly' AND last_run <= ?)",
      Time.now - 1410.minutes, # 23 hours and 30 minutes
      Time.now - 7.days,
      Time.now - 30.days
    )
  }

  def process_and_send(queue_manager)
    CustomQuery.new(sql_query).execute.each do |row|
      queue_manager.enqueue(build_queue_data(row))
    end && update_last_run
  end

  def build_queue_data(row)
    token_values = build_token_values(row)
    {
      device_id: row['device_id'].to_i,
      notification_id: id,
      notification_type: type,
      token_values: token_values,
      title: TokenBasedInterpolations.interpolate(token_values, title),
      body: TokenBasedInterpolations.interpolate(token_values, body),
      processed_discovery: TokenBasedInterpolations.interpolate(token_values, discovery),
      processed_opportunity: TokenBasedInterpolations.interpolate(token_values, opportunity),
      processed_solution: TokenBasedInterpolations.interpolate(token_values, solution)
    }
  end

  def build_token_values(row)
    tokens.split('|').map do |token|
      { token => row[token] }
    end.reduce({}, :merge)
  end

  private

  def update_last_run
    update_attribute(:last_run, Time.now)
  end
end
