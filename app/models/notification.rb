class Notification < ActiveRecord::Base
  def process_and_send
    CustomQuery.new(sql_query).execute.each do |row|
      NotificationSenderQueue.enqueue(
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
