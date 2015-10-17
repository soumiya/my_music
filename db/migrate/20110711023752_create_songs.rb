class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.integer :track_id
      t.string :track_name
      t.string :track_view_url
      t.string :cover_url
      t.string :artist_name
      t.string :genre
      t.text :description
      t.integer :rating
      t.boolean :favorite
      t.references :user

      t.timestamps
    end
    add_index :songs,:track_id
    add_index :songs,:rating
    add_index :songs,:user_id
  end

  def self.down
    drop_table :songs
  end

end
