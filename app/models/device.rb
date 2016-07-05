class Device < ActiveRecord::Base
  has_many :reading_events
end
