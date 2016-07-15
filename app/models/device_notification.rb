class DeviceNotification < ActiveRecord::Base
  belongs_to :device
  belongs_to :notification

  serialize :token_values, Hash
end
