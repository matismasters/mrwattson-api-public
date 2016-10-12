class ComplexQueries
  def self.yesterday_spending(device_id)
    CustomQuery.new(
      'SELECT ' \
      '  round( ' \
      '    ( ' \
      '      ( ' \
      '        ( ' \
      '          SUM(end_read * (seconds_until_next_read)::FLOAT) / ' \
      '          (SUM(seconds_until_next_read)::FLOAT + 1) ' \
      '        ) * 24 ' \
      '     ) / 1000 ' \
      '    ) * 5 ' \
      '  ) as yesterday_spending ' \
      'FROM reading_events ' \
      'WHERE ' \
      "  date_trunc('day', reading_events.created_at) = date_trunc('day', now()::DATE - 1) AND " \
      '  sensor_id = 1 AND ' \
      "  device_id = #{device_id} "
    ).results
  end

  def self.latest_3_hours_spending(device_id)
    CustomQuery.new(
      'SELECT ' \
      '  round( ' \
      '    ( ' \
      '      ( ' \
      '        SUM(end_read * (seconds_until_next_read)::FLOAT) / ' \
      '        (SUM(seconds_until_next_read)::FLOAT + 1) ' \
      '     ) / 1000 ' \
      '    ) * 5 ' \
      '  ) as hourly_spending ' \
      'FROM reading_events ' \
      'WHERE ' \
      '  sensor_id = 1 AND ' \
      "  device_id = #{device_id} AND " \
      "  date_trunc('day', reading_events.created_at) = date_trunc('day', now()::DATE) AND " \
      "  extract('hour' from reading_events.created_at) >= (extract('hour' from now()) - 3) AND " \
      "  extract('hour' from reading_events.created_at) <= (extract('hour' from now()) - 1) " \
      "GROUP BY extract('hour' from reading_events.created_at)"
    ).results
  end
end
