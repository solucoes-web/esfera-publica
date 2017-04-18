class ItemsController < ApplicationController

  # GET /item
  def index
    @items = Item.all
    unless params[:feed].blank?
      @items = Item.feed(params[:feed]).all
    end
  end

  def item_params
    params.require(:item).permit(:name, :summary, :url, :published_at, :guid, :feed)
  end
end
