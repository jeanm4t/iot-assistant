class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false

    new_admin = User.first
    if new_admin
      puts "Making #{new_admin.email} the first admin user."
      new_admin.update_attribute(:admin, true)
    end

  end
end
