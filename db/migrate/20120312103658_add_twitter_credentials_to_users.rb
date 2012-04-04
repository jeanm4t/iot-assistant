class AddTwitterCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_token, :string

    add_column :users, :twitter_secret, :string

    add_column :users, :twitter_username, :string

  end
end
