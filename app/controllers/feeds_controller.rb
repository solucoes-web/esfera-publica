class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /feeds
  def index
    @search = current_user.feeds
    @search = @search.search(params[:search]) if params[:search]
    unless params[:tag].blank?
      @filter = params[:tag]
      @feeds = @search.tagged_with(@filter)
    else
      @feeds = @search.all
      @filter = 'all'
    end
    @path = "feeds_path"
    render layout: 'main'
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
    render layout: "modal"
  end

  # GET /feeds/1/edit
  def edit
    @feed.tag_list = @feed.tags_from(current_user).join(', ')
    render layout: "modal"
  end

  # POST /feeds
  def create
    @feed = Feed.find_or_initialize_by(url: feed_params[:url])

    if @feed.save
      current_user.feeds << @feed
      current_user.tag(@feed, with: feed_params[:tag_list], on: :tags)
      redirect_to feeds_path, notice: 'Feed was successfully created.'
    else
      render :new, error: @feed.errors.messages
    end
  end

  # PATCH/PUT /feeds/1
  def update
    current_user.tag(@feed, with: feed_params[:tag_list], on: :tags)
    redirect_to feeds_path, notice: 'Feed was successfully updated.'
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
