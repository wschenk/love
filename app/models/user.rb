class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  belongs_to :company
  has_many :shouts, foreign_key: "from_user_id"
  
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

end
