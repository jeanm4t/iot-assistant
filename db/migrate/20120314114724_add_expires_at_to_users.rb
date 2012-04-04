class AddExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires_at, :datetime

    User.all.each do |user|
      user.expires_at = Time.now
      user.save!
    end
  end
end
