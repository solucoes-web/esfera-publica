class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :error, :notice

  def get_filter(params)
    filter = 'all'
    params.each do |key, value|
      case key
      when 'favourites', 'bookmarks', 'history'
        filter = key
      when 'tag'
        filter = value unless value.blank?
      end
    end
    filter
  end
end
