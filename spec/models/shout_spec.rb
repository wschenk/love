require 'rails_helper'

RSpec.describe Shout, type: :model do
  let( :shouter ) { create( :user, company: company, name: "Will Schenk" ) }
  let( :company ) { create( :company ) }

  it "should try and create a shout for a message" do
    expect( Shout.all.count ).to eq( 0 )
    Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )

    s = Shout.first
    expect( s ).to_not be_nil

    expect( s.to ).to eq( "Aaron Brocken" )
    expect( s.from ).to eq( "Will Schenk" )
    expect( s.message ).to eq( "that was amazing!" )
    expect( s.from_user ).to_not be_nil
    expect( s.from_user ).to be_a( User )

    expect( s.to_unknown? ).to be_truthy
  end

  it "should associate a shout with a user if they exist" do
    create( :user, company: company, name: "Aaron Brocken" )

    Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )

    s = Shout.first
    expect( s.to_user ).to_not be_nil
    expect( s.to_user.name ).to eq( "Aaron Brocken" )
    expect( s.to_unknown? ).to be_falsey
  end

  it "should only be identified if the to user is found" do
    s = Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )
    expect( s.identified? ).to be_falsey

    create( :user, company: company, name: "Aaron Brocken" )
    s = Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )

    expect( s.identified? ).to be_truthy
  end

  it "should have a list of unidentified shouts" do
    s = Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )
    create( :user, company: company, name: "Aaron Brocken" )
    s = Shout.inbound( shouter, "Aaron Brocken", "that was amazing!" )

    expect( shouter.unidentified_shouts.count ).to eq(1)
    expect( shouter.shouts.count ).to eq(2)
  end

  it "should limit a shout to be 140 characters" do
    s = Shout.inbound( shouter, "Aaron Brocken", "that was amazing!"*20 )

    expect( Shout.count ).to eq(0)
    expect( s.valid? ).to be_falsey
  end
end
