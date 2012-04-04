class AddCalendarsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calendars, :text

    User.all.each do |user|
      user.update_attribute(:calendars, [])
    end

  end
end
