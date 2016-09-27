class UsersController < SecuredApplicationController
  include FindDevice
  before_action :find_device, only: [:assign_device, :unassign_device]

  def index
    render json: current_user.devices, status: 200
  end

  def assign_device
    user_device = UserDevice.find_or_create_by(
      user_id: current_user.id,
      device_id: @device.id
    )

    render json: {}, status: 201
  end

  def unassign_device
    user_device = UserDevice.where(
      user_id: current_user.id,
      device_id: @device.id
    ).first

    if user_device.present?
      user_device.destroy
      render json: {}, status: 200
    else
      render json: {}, status: 422
    end
  end
end
