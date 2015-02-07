class AddCompanyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    add_column :users, :name, :string
    add_index :users, :company_id
  end
end
