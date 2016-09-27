class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :user_devices
  has_many :devices, through: :user_devices

  def update_assigned_devices
    tap { self.assigned_devices = devices.map(&:id).join(',') }.save
  end
end
