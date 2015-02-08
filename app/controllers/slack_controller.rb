class SlackController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
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
        from_user = SlackUser.from_uid params[:user_id]
        to_user = SlackUser.from_username to_user_name
      end

      if from_user.nil?
        render text: "Sorry, I'm not sure who you are"
      elsif to_user.nil?
        render text: "Sorry, I don't know #{to_user_name}"
      else
        to_user.as_user # Triggers creation as a side effect

        Shout.inbound from_user.as_user, to_user.real_name, message
        # Shout.
        render text: "Thanks for giving #{to_user.real_name} some love!"
      end
    else
      render text: "Give the love to a slack user!"
    end
  end
end
