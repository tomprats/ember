class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :uid
      t.string :user_uid
      t.string :deck_uid
      t.string :deck_name
      t.string :personality_type
      t.string :badge
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
