class ReadingEventsController < ApplicationController
  include FindDevice

  before_action :find_device_by_particle_id, only: [:create, :report]

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
    start_date = DateTime.new(*(
      report_permitted_params[:start_date].split('-').map(&:to_i) + [0]
    ))

    end_date = DateTime.new(*(
      report_permitted_params[:end_date].split('-').map(&:to_i) + [0]
    ))

    reading_events = @device.reading_events
      .where('created_at >= ? AND created_at <= ?', start_date, end_date)
      .where('sensor_id = ?', report_permitted_params[:sensor_id])

    total_seconds = 0
    total_w = 0

    csv_string = CSV.generate do |csv|
      csv << reading_events.attribute_names
      reading_events.all.each do |reading_event|
        total_seconds += reading_event.seconds_until_next_read
        total_w += (
          reading_event.seconds_until_next_read *
          reading_event.end_read
        )
        csv << reading_event.attributes.values
      end
      total_kwh = ((total_w / total_seconds) * (total_seconds/3600))
      csv << ["Total seconds, #{total_seconds}, kW/h , #{total_kwh}"]
    end



    render text: csv_string, status: 200
  end

  private

  def permitted_params
    params.permit(:device_id, :data)
  end

  def report_permitted_params
    params.permit(:device_id, :sensor_id, :start_date, :end_date)
  end
end
