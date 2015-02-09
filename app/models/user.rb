class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  belongs_to :company
  has_many :shouts, foreign_key: "from_user_id"

  attr_accessor :current_shout
  attr_accessor :current_password

  
  def unidentified_shouts
    shouts.where( "identified" => false )
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
         
  def google_oauth2
    identities.where( :provider => "google_oauth2" ).first
  end

  def google_oauth2_client
    @google_oauth2_client ||= GoogleAppsClient.client( google_oauth2 )
  end

  def twitter
    identities.where( :provider => "twitter" ).first
  end

  def twitter_client
    @twitter_client ||= Twitter.client( access_token: twitter.accesstoken )
  end

  def send_devise_notification(*args)
    if args[0] != :invitation_instructions || current_shout.nil?
      super( *args )
    else
      if current_shout.from_user.id == self.id
        ShoutMailer.welcome_sent_shout(self, current_shout).deliver_later
      else
        ShoutMailer.welcome_received_shout(self, current_shout).deliver_later
      end        
    end
  end
end
