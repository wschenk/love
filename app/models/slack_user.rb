require 'slack'

class SlackUser < ActiveRecord::Base
  def self.from_uid( uid )
    where( uid: uid.downcase ).first
  end

  def self.from_username name
    where( name: name.downcase ).first
  end

  def self.sync_with_slack
    Slack.configure do |config|
      config = ENV['xoxp-2452601099-2452601107-3650598663-873f40']
  end
end
