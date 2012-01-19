class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|

      t.timestamps
    end
  end
end
