class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :graph_id
      t.string :from_name
      t.string :from_id
      t.text :message
      t.string :picture
      t.string :link
      t.string :name
      t.text :description
      t.string :icon
      t.datetime :shared_at

      t.timestamps
    end
  end
end
