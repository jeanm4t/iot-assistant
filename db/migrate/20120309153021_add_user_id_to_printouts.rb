class AddUserIdToPrintouts < ActiveRecord::Migration
  def change
    add_column :printouts, :user_id, :integer
  end
end
