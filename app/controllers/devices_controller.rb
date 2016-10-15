class DevicesController < SecuredApplicationController
  include FindDevice

  before_action :find_device

  def notifications
    render(
      json: {
        notifications: @device.device_notifications
          .order('created_at::DATE desc, notification_id')
      },
      status: 200
    )
  end

  def active_opportunities
    render(
      json: {
        notifications: @device.active_opportunities
      },
      status: 200
    )
  end

  def latest
    render json: @device.sensors_last_reads, status: 200
  end

  def latest_spendings
    eight_days_ago_spendings =
      ComplexQueries.yesterday_from_last_week_spendings @device.id
    one_day_ago_spendings =
      ComplexQueries.yesterday_spendings @device.id
    latest_hours_spendings =
      ComplexQueries.latest_6_hours_spendings @device.id

    render(
      json: {
        latest_spendings: {
          yesterday_from_last_week:
            eight_days_ago_spendings.first['daily_spendings'].to_f,
          yesterday:
            one_day_ago_spendings.first['daily_spendings'].to_f,
          latest_6_hours:
            latest_hours_spendings.first['hourly_spendings'].to_f
        }
      },
      status: 200
    )
  end

  def configuration
    render json: { configuration: @device.configuration() }, status: 200
  end

  def update_configuration
    @device.configuration = @device.configuration.merge(configuration_params)

    if @device.save
      render json: {}, status: 200
    else
      render json: @device.errors, status: 422
    end
  end

  private

  def configuration_params
    params.require(:configuration)
  end
end
