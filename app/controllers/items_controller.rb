class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update]
  before_action :authenticate_user!

  # GET /items
  def index
    begin
      @search = current_user.items.cumulative_filters(params)
    rescue Exception => e
      redirect_to items_path, error: e.message
      return
    end
    @items = @search.exclusive_filters(current_user, params).latest(20)
    @filter = get_filter(params)

    render layout: 'main'
  end

  # GET /items/1
  def show
    current_user.read(@item)
    render layout: 'modal'
  end

  # PATCH /interact/1
  def interact
    set_item
    current_user.toggle_favourite(@item) if params[:favourite]
    current_user.toggle_bookmark(@item) if params[:bookmark]
    respond_to do |format|
      format.html{ redirect_to items_path }
      format.js do
        filters = current_user.items.cumulative_filters(params)
        @bookmarks_count = filters.bookmarks(current_user).count
        @favourites_count = filters.favourites(current_user).count
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:name, :summary, :url, :published_at, :guid,
                                 :feed, :favourite)
  end
end
