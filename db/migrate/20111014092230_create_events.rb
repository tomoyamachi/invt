class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.string :category
      t.text :note
      t.datetime :dead_line
      t.integer :open_flag

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
