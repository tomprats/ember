class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :uid
      t.string :name
      t.string :link
      t.string :about

      t.timestamps
    end
  end
end
