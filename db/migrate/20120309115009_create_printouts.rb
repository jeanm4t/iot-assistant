class CreatePrintouts < ActiveRecord::Migration
  def change
    create_table :printouts do |t|
      t.text :content
      t.boolean :printed, :default => false

      t.timestamps
    end
  end
end
