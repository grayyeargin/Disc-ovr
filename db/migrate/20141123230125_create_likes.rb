class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user
      t.string :artist_name
      t.string :image_url
      t.string :artist_url
      t.timestamps
    end
  end
end
