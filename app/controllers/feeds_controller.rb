class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  # GET /feeds.json
  def index
    if params[:tag]
      @feeds = Feed.tagged_with(params[:tag])
      @filter = params[:tag]
    else
      @feeds = Feed.all
      @filter = 'all'
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @items = @feed.items.latest(20)
    render template: "items/index"
  end

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
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    if @feed.save
      redirect_to feeds_path, notice: 'Feed was successfully created.'
    else
      render :new, error: @feed.errors.messages
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to feeds_path, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
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
