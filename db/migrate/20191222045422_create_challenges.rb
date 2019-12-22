class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :description
      t.text :question
      t.string :category
      t.integer :difficulty_level
      t.references :user

      t.timestamps
    end
  end
end
