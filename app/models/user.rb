class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :user_devices
  has_many :devices, through: :user_devices
end
