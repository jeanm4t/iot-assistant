class AddScheduleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :schedule, :text

  end
end
