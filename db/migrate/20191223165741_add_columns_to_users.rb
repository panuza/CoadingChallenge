class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :vote_count, :integer, default: 0
    add_column :users, :skill_level, :integer, default: 0
  end
end
