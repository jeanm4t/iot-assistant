class AddLastScheduledPrintAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_scheduled_print_at, :datetime

  end
end
