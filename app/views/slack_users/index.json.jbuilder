json.array!(@slack_users) do |slack_user|
  json.extract! slack_user, :id, :name, :uid, :real_name, :email
  json.url slack_user_url(slack_user, format: :json)
end
