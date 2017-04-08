class ItemsController < ApplicationController
  #  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_item, only: :show

  # GET /items
  # GET /items.json
  def index
    @search = params[:search] ? Item.search(params[:search]) : Item

    unless params[:tag].blank?
      @filter = params[:tag]
      @items = @search.tagged_with(@filter).latest(20)
    else
      @items = @search.latest(20)
      @filter = 'latest'
    end
  end

  # GET /items/1
  # GET /items/1.json
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
