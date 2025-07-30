class AddColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :gender, :integer
    add_column :users, :address, :string
    add_column :users, :avatar, :string
    add_column :users, :role, :integer
    add_column :users, :status, :integer
    add_column :users, :last_login_at, :datetime
    add_column :users, :last_login_ip, :string
  end
end
