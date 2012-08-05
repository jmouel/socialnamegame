class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :photo_url
      t.integer :gender
      t.integer :provider

      t.timestamps
    end
  end
end
