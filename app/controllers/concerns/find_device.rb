module FindDevice
  extend ActiveSupport::Concern

  def find_device
    @device = Device.where(id: params.require(:device_id)).first

    puts params
    render json: { device_id: 'not found' }, status: 404 unless @device.present?
  end

  def find_device_by_particle_id
    @device = Device.find_by_particle_id(params.require(:device_id))

    puts params
    render json: { device_id: 'not found' }, status: 404 unless @device.present?
  end
end
