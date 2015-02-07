class Shout < ActiveRecord::Base
  belongs_to :from_user, class: User
  belongs_to :to_user, class: User

  def self.inbound( from, to_name, message )
    return nil if from.nil?
    to_user = from.company.users.where( ["lower(users.name) = ?", to_name.downcase] ).first
    Shout.create( from_user_id: from.id, from: from.name, to: to_name, message: message, to_user: to_user, identified: !to_user.nil? )
  end

  def to_unknown?
    to_user_id.nil?
  end
end
