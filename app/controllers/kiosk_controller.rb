class KioskController < ApplicationController
  def index
    @shout = Shout.first
  end

  def next_shout
    if( session[:last_id] )
      @shout = Shout.where( "id < ?", session[:last_id] ).order("id desc").limit( 1 ).first
    end

    if @shout.nil?
      @shout = Shout.order("id desc").first
    end

    session[:last_id] = @shout.id

    render json: @shout.to_json
  end
end
