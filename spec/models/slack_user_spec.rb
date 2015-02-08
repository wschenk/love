require 'rails_helper'

RSpec.describe SlackUser, type: :model do
  let( :slack_user ) { create( :slack_user, uid: "a123", name: "will", real_name: "Will Schenk" ) }

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
end