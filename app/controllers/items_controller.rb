class ItemsController < ApplicationController

  # GET /item
  def index
   begin
     @search = Item.cumulative_filters(params)
   rescue Exception => e
     redirect_to items_path, error: e.message
     return
   end
   @items = @search.latest(20) # pegas os últimos 20 encontrados
  end

  def item_params
    params.require(:item).permit(:name, :summary, :url, :published_at, :guid, :feed)
  end
end
