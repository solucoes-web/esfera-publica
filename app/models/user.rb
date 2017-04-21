class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :feeds
  has_many :items, through: :feeds
  has_many :interactions
  acts_as_tagger

  ["favourite", "bookmark", "read"].each do |interaction|
    # bookmark, favourite e read 
    define_method(interaction) do |item|
      inter = interactions.find_or_create_by(item: item)
      inter.send(interaction + "=", true)
      inter.save
    end

    # unbookmark, unfavourite e unread
    define_method("un" + interaction) do |item|
      inter = interactions.find_by(item: item)
      inter.send(interaction + "=", false)
      inter.save
    end

    # toggle_bookmark, toggle_favourite e toggle_read
    define_method("toggle_" + interaction) do |item|
      inter = interactions.find_or_create_by(item: item)
      inter.toggle!(interaction)
    end

    # bookmarks, favourites e history
    name = (interaction == 'read' ? 'history' : interaction + 's')
    define_method(name) do
      Item.joins(:interactions).
      where("interactions.user_id = ? AND #{interaction} = ?", id, true)
    end
  end
end
