class AddExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires_at, :datetime

    User.all.each do |user|
      user.update_attribute(:expires_at, Time.now)
    end
  end
end
