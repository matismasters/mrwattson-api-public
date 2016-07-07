class VersionsController < ApplicationController
  VERSION_NUMBER = '1.2'.freeze

  def show
    @version_number = VERSION_NUMBER
  end
end
