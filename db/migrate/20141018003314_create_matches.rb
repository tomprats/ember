class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :user_uid
      t.string :match_uid
      t.boolean :response, default: false
      t.boolean :mutual, default: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
