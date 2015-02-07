json.array!(@shouts) do |shout|
  json.extract! shout, :id, :company_id, :to, :to_user_id, :from, :from_user_id, :message, :identified, :public
  json.url shout_url(shout, format: :json)
end
