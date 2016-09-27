class UserDevice < ActiveRecord::Base
  belongs_to :device
  validates :device, uniqueness: { scope: :user_id }

  belongs_to :user
  validates :user, uniqueness: { scope: :device_id }

  after_save :update_user_assigned_devices

  private

  def update_user_assigned_devices
    user.reload.update_assigned_devices
  end
end
