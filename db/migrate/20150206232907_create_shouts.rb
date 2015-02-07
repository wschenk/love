class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.integer :company_id
      t.string :to
      t.integer :to_user_id
      t.string :from
      t.integer :from_user_id
      t.string :message
      t.boolean :identified
      t.boolean :public

      t.timestamps null: false
    end
  end
end
