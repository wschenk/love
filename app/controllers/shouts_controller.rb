 
 
class ShoutsController < ApplicationController
  before_action :set_shout, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @shouts = Shout.all
  end 

  def show
  end 

  def new 
    @shout = Shout.new
  end 

  def edit
  end 

  def create
    @shout = Shout.new(shout_params)
    @shout.save
    respond_with(@shout)
  end 

  def update
    @shout.update(shout_params)
    flash[:notice] = 'Shout was successfully updated.'
    respond_with(@shout)
  end 

  def destroy
    @shout.destroy
    redirect_to shouts_url, notice: 'Shout was successfully destroyed.'
  end 

  private
    def set_shout
      @shout = Shout.find(params[:id])
    end 

    def shout_params
      params.require(:shout).permit(:company_id, :to, :to_user_id, :from, :from_user_id, :message, :identified, :public) 
    end 
end
 
