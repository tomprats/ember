class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :page_uid
      t.string :user_uid

      t.timestamps
    end
  end
end
