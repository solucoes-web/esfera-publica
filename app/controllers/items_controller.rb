class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update]
  before_action :authenticate_user!

  # GET /items
  def index
    @search = current_user.items
    @search = @search.search(params[:search]) if params[:search]
    unless params[:calendar].blank?
      begin
        date = Date.strptime(params[:calendar], "%d/%m/%Y")
      rescue
        redirect_to items_path, error: "Data inválida"
      end
      @search = @search.date_published(date)
    end

    if params[:favourites]
      @filter = 'favourites'
      @items = @search.favourites(current_user).latest(20)
    elsif params[:bookmarks]
      @filter = 'bookmarks'
      @items = @search.bookmarks(current_user).latest(20)
    elsif params[:history]
      @filter = 'history'
      @items = @search.history(current_user).latest(20)
    elsif !params[:tag].blank?
      @filter = params[:tag]
      @items = @search.tagged_with(@filter).latest(20)
    elsif !params[:feed].blank?
      @items = @search.feed(params[:feed]).latest(20)
    else
      @items = @search.latest(20)
      @filter = 'all'
    end
    @path = "items_path"
    render layout: 'main'
  end

  # GET /items/1
  def show
    current_user.read(@item)
    render layout: 'modal'
  end

  # PATCH /items/1
  def update
    current_user.favourite(@item) if params[:favourite]
    current_user.bookmark(@item) if params[:bookmark]
    redirect_to items_path
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
