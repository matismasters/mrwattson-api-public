class Notification < ActiveRecord::Base
  def process_and_send(queue_manager)
    NotificationSenderQueue.enqueue(1, 2, 3)
    CustomQuery.new(sql_query).execute.each do |row|
      queue_manager.enqueue(
        row['device_id'].to_i,
        title,
        TokenBasedInterpolations.interpolate(
          self.build_token_replacements(row),
          body
        )
      )
    end
  end

  def build_token_replacements(row)
    tokens.split('|').map do |token|
      { token => row[token] }
    end.reduce({}, :merge)
  end
end
