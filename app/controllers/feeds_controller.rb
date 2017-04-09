class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  def index
    @search = params[:search] ? Feed.search(params[:search]) : Feed
    unless params[:tag].blank?
      @filter = params[:tag]
      @feeds = @search.tagged_with(@filter)
    else
      @feeds = @search.all
      @filter = 'all'
    end
    @path = "feeds_path"
  end

  # GET /feeds/1
  # decidi acabar com isso e passar o feed como um parâmetro para items
#  def show
#    @items = @feed.items.latest(20)
#    @search = Item
#    @path = "items_path"
#    render template: "items/index"
#  end

  # GET /feeds/new
  def new
    @feed = Feed.new
    render layout: "modal"
  end

  # GET /feeds/1/edit
  def edit
    render layout: "modal"
  end

  # POST /feeds
  def create
    @feed = Feed.new(feed_params)
    if @feed.save
      redirect_to feeds_path, notice: 'Feed was successfully created.'
    else
      render :new, error: @feed.errors.messages
    end
  end

  # PATCH/PUT /feeds/1
  def update
    if @feed.update(feed_params)
      redirect_to feeds_path, notice: 'Feed was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy
    redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:name, :url, :favicon, :tag_list)
    end
end
