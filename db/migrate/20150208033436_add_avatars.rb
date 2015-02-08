class AddAvatars < ActiveRecord::Migration
  def change
    add_column :slack_users, :avatar, :string
    add_column :users, :avatar, :string
  end
end
