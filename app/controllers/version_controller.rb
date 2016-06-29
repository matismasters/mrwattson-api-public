class VersionController < ApplicationController
  VERSION_NUMBER = '1.1'

  def show
    @version_number = VERSION_NUMBER
  end
end
