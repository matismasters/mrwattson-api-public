class UserDevice < ActiveRecord::Base
  belongs_to :device
  validates :device, uniqueness: { scope: :user_id }

  belongs_to :user
  validates :user, uniqueness: { scope: :device_id }
end
