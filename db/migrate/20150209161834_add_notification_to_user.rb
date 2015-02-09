class AddNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :sms_notification, :boolean, default: true
    add_column :users, :shouts_notification, :boolean, default: true
    add_column :users, :daily_notification, :boolean, default: true
    add_column :users, :weekly_notification, :boolean, default: true
  end
end
