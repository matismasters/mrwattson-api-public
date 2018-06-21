class ReadingEventsController < ApplicationController
  include FindDevice

  before_action :find_device_by_particle_id, only: %i[create report]

  def create
    factory = ReadingEventsCreator.new(
      @device,
      permitted_params.require(:data)
    )
    factory.create_reading_events

    if factory.no_errors?
      render json: factory.created_reading_events, status: 201
    else
      render json: factory.errors, status: 422
    end
  end

  def report
    render text: generate_csv_string(find_reading_events), status: 200
  end

  private

  def param_date_to_date(param_date)
    DateTime.new(*(
      param_date.split('-').map(&:to_i) + [0]
    ))
  end

  def find_reading_events
    start_date = param_date_to_date(report_permitted_params[:start_date])
    end_date = param_date_to_date(report_permitted_params[:end_date])

    @device.reading_events
      .where('created_at >= ? AND created_at <= ?', start_date, end_date)
      .where('sensor_id = ?', report_permitted_params[:sensor_id])
  end

  def generate_csv_string(reading_events)
    total_seconds = 0
    total_w = 0

    CSV.generate do |csv|
      csv << reading_events.attribute_names
      reading_events.all.each do |reading_event|
        total_seconds += reading_event.seconds_until_next_read
        total_w += (
          reading_event.seconds_until_next_read * reading_event.end_read
        )
        csv << reading_event.attributes.values
      end
      total_wh = ((total_w.to_f / total_seconds) * (total_seconds.to_f / 3600))
      csv << ["Total seconds, #{total_seconds}, w/h , #{total_wh}"]
    end
  end

  def permitted_params
    params.permit(:device_id, :data)
  end

  def report_permitted_params
    params.permit(:device_id, :sensor_id, :start_date, :end_date)
  end
end
