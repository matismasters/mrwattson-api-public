module TimestampsInMontevideoTimeZone
  extend ActiveSupport::Concern

  def created_at
    in_montevideo(attributes['created_at'])
  end

  def updated_at
    in_montevideo(attributes['updated_at'])
  end

  def in_montevideo(time)
    time.present? ? time.in_time_zone('Montevideo') : nil
  end
end
