class CreateSlackUsers < ActiveRecord::Migration
  def change
    create_table :slack_users do |t|
      t.string :name
      t.string :uid
      t.string :real_name
      t.string :email

      t.timestamps null: false
    end
  end
end
