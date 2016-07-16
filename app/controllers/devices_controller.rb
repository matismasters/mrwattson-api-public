class DevicesController < ApplicationController
  include FindDevice
  
  before_action :find_device, only: [:create, :latest]
end
