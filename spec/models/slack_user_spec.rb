require 'rails_helper'

ENV['SLACK_API_TOKEN'] = 'xoxp-2452601099-2452601107-3650598663-873f40'

RSpec.describe SlackUser, type: :model do
  before :all do
    Devise.mappings[:user] = Devise::Mapping.new(:user, {})
  end

  before :each do
    ActionMailer::Base.deliveries.clear
  end
  
  let( :slack_user ) { create( :slack_user, uid: "a123", name: "will", real_name: "Will Schenk", email: "will@happyfuncorp.com", avatar: "123" ) }

  it "should look for SlackUser by uid" do
    expect( slack_user.uid ).to eq( "a123" )
    s = SlackUser.from_uid "A123"
    expect( s ).to_not be_nil
    expect( s.uid ).to eq( "a123" )
  end

  it "should look for SlackUser by username" do
    expect( slack_user.name ).to eq("will")
    s = SlackUser.from_username "Will"
    expect( s ).to_not be_nil
    expect( s.uid ).to eq( "a123" )
  end

  it "should sync with slack" do
    VCR.use_cassette "slack/sync_with_slack" do
      expect( SlackUser.count ).to eq(0)
      SlackUser.sync_with_slack
      expect( SlackUser.count ).to_not eq(0)
      su = SlackUser.where( email: "will@happyfuncorp.com").first
      expect( su.uid ).to_not be_nil
      expect( su.name ).to_not be_nil
      expect( su.real_name ).to_not be_nil
      expect( su.avatar ).to_not be_nil
    end
  end

  it "should create the user and company from the name" do
    u = slack_user.as_user

    expect( u.company ).to_not be_nil
    expect( u.company.domain ).to eq( "happyfuncorp.com" )
    expect( u.email ).to eq( slack_user.email )
    expect( u.avatar ).to eq( slack_user.avatar )
  end

  it "should not invite message when a user is created" do
    expect( User.count ).to eq(0)
    u = slack_user.as_user

    expect( u.invited_to_sign_up? ).to be_falsey

    expect( ActionMailer::Base.deliveries.last ).to be_nil
  end
end