require 'rails_helper'

RSpec.describe "SlackUsers", type: :request do
  describe "GET /slack_users" do
    it "works! (now write some real specs)" do
      get slack_users_path
      expect(response).to have_http_status(200)
    end
  end
end
