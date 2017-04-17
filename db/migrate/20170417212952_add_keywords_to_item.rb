class AddKeywordsToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :keywords, :string
  end
end
