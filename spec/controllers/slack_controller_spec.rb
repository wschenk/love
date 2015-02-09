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

  before :each do 
    ENV['SLACK_API_TOKEN'] ||= 'token'
    Devise.mappings[:user] = Devise::Mapping.new(:user, {})
    ActionMailer::Base.deliveries.clear
  end

  it "should only accept something with the correct token" do
    message[:token]="asdf"
    post :message

    expect( response.status ).to eq( 401 )
  end

  it "should only accept messages that have a user in front" do
    message[:text] = "message"
    post :message, message
    expect( response.body ).to eq( "Give the love to a slack user!" )
  end

  it "should find the slack users if they don't exist" do
    VCR.use_cassette 'slack/sync_with_slack' do
      post :message, message
      

      u = SlackUser.where( email: "will@happyfuncorp.com" ).first
      expect( u ).to_not be_nil

      u = SlackUser.where( email: "aaron@happyfuncorp.com" ).first
      expect( u ).to_not be_nil

      expect( response.body ).to eq("Thanks for giving Aaron Brocken some love!")
    end
  end

  it "should require the to slack user to actually exist" do
    message[:text] = "@asdfasdfjasdfasdf loved it"
    VCR.use_cassette 'slack/sync_with_slack' do
      post :message, message
      expect( response.body ).to eq( "Sorry, I don't know asdfasdfjasdfasdf" )
    end
  end

  it "should create the shout" do
    VCR.use_cassette 'slack/sync_with_slack' do
      expect( Shout.count ).to eq(0)
      post :message, message

      s = Shout.first
      expect( s ).to_not be_nil
    end
  end

  it "should create the user object" do
    VCR.use_cassette 'slack/sync_with_slack' do
      expect( Shout.count ).to eq(0)
      post :message, message

      s = Shout.first

      expect( s.from_user ).to_not be_nil
      expect( s.to_user ).to_not be_nil
      expect( s.message ).to eq( "great work!" )
    end
  end

  it "should invite the sender" do
    VCR.use_cassette 'slack/sync_with_slack' do
      expect( Shout.count ).to eq(0)
      post :message, message

      email = ActionMailer::Base.deliveries.select { |x| x.to.first == 'will@happyfuncorp.com' }.first

      expect( email ).to_not be_nil

      expect( email.to ).to eq( ['will@happyfuncorp.com'] )
      expect( email.body ).to have_content( "Thanks for sharing the love" )
      expect( email.subject ).to have_content( "Welcome to Love" )
    end
  end

  it "should invite the receiver" do
    VCR.use_cassette 'slack/sync_with_slack' do
      expect( Shout.count ).to eq(0)
      post :message, message

      email = ActionMailer::Base.deliveries.select { |x| x.to.first == 'aaron@happyfuncorp.com' }.first

      expect( email ).to_not be_nil

      expect( email.to ).to eq( ['aaron@happyfuncorp.com'] )
      expect( email.body ).to have_content( "You've been sent from love" )
      expect( email.subject ).to have_content( "Getting some love" )
    end
  end

  it "should send a shout message to the receiver" do
    create( :user, email: "aaron@happyfuncorp.com", password: "12345678", password_confirmation: "12345678" )
    VCR.use_cassette 'slack/sync_with_slack' do
      expect( Shout.count ).to eq(0)
      post :message, message

      email = ActionMailer::Base.deliveries.select { |x| x.to.first == 'aaron@happyfuncorp.com' }.first

      expect( email ).to_not be_nil

      expect( email.to ).to eq( ['aaron@happyfuncorp.com'] )
      expect( email.body ).to have_content( "You've been sent from love" )
      expect( email.subject ).to have_content( "Getting some love" )
    end
  end
end