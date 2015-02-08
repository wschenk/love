class KioskController < ApplicationController
  def index
    @shout = Shout.first
  end
end
