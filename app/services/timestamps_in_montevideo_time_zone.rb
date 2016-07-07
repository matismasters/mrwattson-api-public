module TimestampsInMontevideoTimeZone
  def self.in_montevideo(time)
    time.present? ? time.in_time_zone('Montevideo') : nil
  end
end
