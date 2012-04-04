class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :token
      t.string :image
      t.string :name
      t.string :email
      t.text :print_options

      t.timestamps
    end
  end
end
