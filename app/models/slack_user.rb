require 'slack'

class SlackUser < ActiveRecord::Base
  def self.from_uid( uid )
    where( uid: uid.downcase ).first
  end

  def self.from_username name
    where( name: name.downcase ).first
  end

  def self.sync_with_slack
    if ENV['SLACK_API_TOKEN'].blank?
      logger.error "ENV['SLACK_API_TOKEN'] not set, not syncing slack"
      return
    end

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    logger.info "Loading user list from slack"
    r =  Slack.client.users_list
    if !r['ok']
      logger.error "Couldn't sync slack, #{r}"
      return
    end

    r['members'].each do |member|
      s = SlackUser.where( uid: member['id'].downcase ).first_or_create
      s.name = member['name']
      s.real_name = member['profile']['real_name']
      s.email = member['profile']['email']
      s.avatar = member['profile']['image_192']
      s.save
    end
  end

  def as_user
    u = User.where( slack_uid: uid ).first || User.where( email: email ).first
    return u unless u.nil?

    domain = email.gsub( /.*@/, "" ).downcase

    c = Company.where( domain: domain ).first_or_create

    u = c.users.create( email: email, slack_uid: uid, slack_name: name, name: real_name, avatar: avatar )
    u
  end
end
