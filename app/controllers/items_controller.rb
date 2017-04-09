class ItemsController < ApplicationController
  before_action :set_item, only: :show

  # GET /items
  def index
    @search = params[:search] ? Item.search(params[:search]) : Item
    unless params[:calendar].blank?
      date = Date.strptime(params[:calendar], "%d/%m/%Y")
      @search = @search.date_published(date)
    end

    if !params[:tag].blank?
      @filter = params[:tag]
      @items = @search.tagged_with(@filter).latest(20)
    elsif !params[:feed].blank?
      @items = @search.feed(params[:feed]).latest(20)
    else
      @items = @search.latest(20)
      @filter = 'all'
    end
    @path = "items_path"
  end

  # GET /items/1
  def show
    render layout: 'modal'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :summary, :url, :published_at, :guid, :feed)
    end
end
