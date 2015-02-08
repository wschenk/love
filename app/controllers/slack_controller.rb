class SlackController < ApplicationController
  def message
    if params[:token] != ENV['SLACK_MESSAGE_TOKEN']
      render text: "Unauthorized access", status: 401
      return
    end

    if params[:text] =~ /^\s*@([^\s]*)\s(.*)/
      to_user_name = $1
      message = $2
      from_user = SlackUser.from_uid params[:user_id]
      to_user = SlackUser.from_username to_user_name

      if to_user.nil? || from_user.nil?
        SlackUser.sync_with_slack
        from_user = SlackUser.from_uid params[:user_id].downcase
        to_user = SlackUser.from_username to_user_name
      end

      if from_user.nil?
        render text: "Sorry, I'm not sure who you are"
      elsif to_user.nil?
        render text: "Sorry, I don't know #{to_user_name}"
      else
      end
    else
      render text: "Give the love to a slack user!"
    end
  end
end
