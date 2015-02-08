require 'rails_helper'

ENV['SLACK_MESSAGE_TOKEN'] = 'token'
RSpec.describe SlackController, :type => :controller do
  let( :message ) {
    {
      token: "token",
      team_id: "T0001",
      channel_id: "C2147483705",
      channel_name: "test",
      user_id: "U02DAHP35",
      user_name: "will",
      command: "love",
      text: "@xbrockenx great work!"
    }
  }
  it "should only accept something with the correct token" do
    post :message

    expect( response.status ).to eq( 401 )
  end

  it "should only accept messages that have a user in front" do
    message[:text] = "message"
    post :message, message
    expect( response.body ).to eq( "Give the love to a slack user!" )
  end

  it "should create the users if they don't exist" do
    post :message, message
    u = User.where( email: "will@happyfuncorp.com" ).first
    expect( u ).to_not be_nil

    u = User.where( email: "aaron@happyfuncorp.com" ).first
    expect( u ).to_not be_nil
  end
end

# token=j5ZCnlrUHkKMwpARbSMicSXX
# team_id=T0001
# channel_id=C2147483705
# channel_name=test
# user_id=U2147483697
# user_name=Steve
# command=/weather
# text=94070