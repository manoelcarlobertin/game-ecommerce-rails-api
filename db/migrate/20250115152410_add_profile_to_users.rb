class AddProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile, :integer unless column_exists?(:users, :profile)
  end
end

