class NewsObjectsController < ApplicationController

  def create
    news = NewsObject.create permit_params

    rss_url = permit_params[:rss]
    unless rss_url.blank?
      feed = Feedjira::Feed.fetch_and_parse(rss_url)
      news.update_attributes(:news => feed.entries.to_json)
    end

    respond_to do |format|
      @news_objects = NewsObject.all
      format.js { render action: "show"}
    end
  end

  def update
    news = NewsObject.find(params["id"])
    news.update_attributes permit_params

    respond_to do |format|  
      @news_objects = NewsObject.all
      format.js { render action: "show"}
    end
  end

  def destroy
    NewsObject.destroy(params["id"])

    respond_to do |format|
      @news_objects = NewsObject.all
      format.js { render action: "show"}
    end
  end

  private

  def permit_params
    params.require(:news_object).permit :x, :y, :rss, :news, :exclusion
  end
end