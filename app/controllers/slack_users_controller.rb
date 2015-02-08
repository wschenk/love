 
 
class SlackUsersController < ApplicationController
  before_action :set_slack_user, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @slack_users = SlackUser.all
  end 

  def show
  end 

  def new 
    @slack_user = SlackUser.new
  end 

  def edit
  end 

  def create
    @slack_user = SlackUser.new(slack_user_params)
    @slack_user.save
    respond_with(@slack_user)
  end 

  def update
    @slack_user.update(slack_user_params)
    flash[:notice] = 'Slack user was successfully updated.'
    respond_with(@slack_user)
  end 

  def destroy
    @slack_user.destroy
    redirect_to slack_users_url, notice: 'Slack user was successfully destroyed.'
  end 

  private
    def set_slack_user
      @slack_user = SlackUser.find(params[:id])
    end 

    def slack_user_params
      params.require(:slack_user).permit(:name, :uid, :real_name, :email) 
    end 
end
 
