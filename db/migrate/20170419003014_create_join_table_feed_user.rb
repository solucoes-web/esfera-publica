class CreateJoinTableFeedUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :feeds, :users do |t|
      # t.index [:feed_id, :user_id]
      # t.index [:user_id, :feed_id]
    end
  end
end
