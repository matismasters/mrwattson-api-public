module FindDevice
  extend ActiveSupport::Concern

  def find_device
    @device = Device.find_by_particle_id(permitted_params.require(:device_id))

    render json: { device_id: 'not found' }, status: 404 unless @device.present?
  end
end
