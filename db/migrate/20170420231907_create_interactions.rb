class CreateInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :interactions do |t|
      t.boolean :favourite
      t.boolean :read
      t.boolean :bookmark
      t.references :user
      t.references :item

      t.timestamps
    end
  end
end
