class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.string :favicon

      t.timestamps
    end
  end
end
