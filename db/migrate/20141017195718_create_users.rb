class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :link
      t.string :about
      t.string :gender
      t.string :interested_in
      t.string :location
      t.string :birthday

      t.timestamps
    end
  end
end
