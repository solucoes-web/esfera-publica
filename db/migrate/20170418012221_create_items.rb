class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :summary
      t.datetime :published_at
      t.string :guid
      t.references :feed, foreign_key: true

      t.timestamps
    end
  end
end
