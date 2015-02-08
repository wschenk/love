class AddSlackIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :slack_uid, :string
    add_column :users, :slack_name, :string
    add_index :users, :slack_uid
    add_index :users, :slack_name
  end
end
