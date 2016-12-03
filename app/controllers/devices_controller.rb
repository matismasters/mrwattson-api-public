class DevicesController < SecuredApplicationController
  include FindDevice

  skip_before_filter :authenticate_user!, only: [:smart_plugs]
  before_action :find_device, except: [:smart_plugs]

  def notifications
    render(
      json: {
        notifications: @device.device_notifications.limit(120)
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
    render(
      json: {
        sensors_last_reads: @device.last_reading_events_reads,
        status: 200
      }
    )
  end

  def smart_plugs
    devices =
      Device.where(id: smart_plugs_permitted_params[:device_ids].split(','))

    render(
      json: {
        devices: devices.map { |device| device.last_reading_events_reads },
        status: 200
      }
    )
  end

  def latest_spendings
    eight_days_ago_spendings =
      ComplexQueries.yesterday_from_last_week_spendings @device.id
    one_day_ago_spendings =
      ComplexQueries.yesterday_spendings @device.id

    render(
      json: {
        latest_spendings: {
          yesterday_from_last_week:
            eight_days_ago_spendings.first['daily_spendings'].to_f,
          yesterday:
            one_day_ago_spendings.first['daily_spendings'].to_f
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

  def smart_plugs_permitted_params
    params.permit(:device_ids)
  end
end
