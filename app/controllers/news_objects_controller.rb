class NewsObjectsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def create
    news = NewsObject.create permit_params

    rss_url = permit_params[:rss]
    feed_content = rss_url.blank? ? "" : strip_tags(fetch_rss(rss_url))
    keywords = extract_keywords feed_content, news.exclusion
    
    news.update_attributes :keywords => keywords.to_s, :news => feed_content
    
    respond_to do |format|
      @news_objects = NewsObject.all
      @news_objects_position = NewsObject.all.select(:id, :x, :y)
      format.js { render action: "show"}
    end
  end

  def update
    news = NewsObject.find(params["id"])
    news.update_attributes permit_params

    rss_url = news.rss
    feed_content = rss_url.blank? ? "" : strip_tags(fetch_rss(rss_url))
    keywords = extract_keywords feed_content, news.exclusion

    news.update_attributes :keywords => keywords.to_s, :news => feed_content

    respond_to do |format|  
      @news_objects = NewsObject.all
      @news_objects_position = NewsObject.all.select(:id, :x, :y)
      format.js { render action: "show"}
    end
  end

  def destroy
    NewsObject.destroy(params["id"])

    respond_to do |format|
      @news_objects = NewsObject.all
      @news_objects_position = NewsObject.all.select(:id, :x, :y)
      format.js { render action: "show"}
    end
  end

  private

  def permit_params
    params.require(:news_object).permit :x, :y, :rss, :news, :exclusion
  end

  def extract_keywords(news, exclusion)
    exclusion = exclusion.nil? ? '' : exclusion.downcase
    news = news.nil? ? '' : news.downcase

    # Replace tailing dot with space
    news = news.gsub('.', ' ')
    news = news.squish

    # Remove whitespace from the exlucsion keywords
    exclusion = exclusion.delete(' ')
    exclusion_list = exclusion.split(/,/)

    # Tokenize news with whitespace
    news_segment = Hash.new(0)
    news.split(/ /).each do |word|
      # check exclusion array contains a word
      news_segment[word.strip] += 1 unless exclusion_list.include? word.strip
    end

    # Sort news hash by word count
    news_segment = Hash[news_segment.sort_by { |_k, v| v }.reverse]

    news_keywords_array = []
    json_result = Hash.new(0)
    (0..4).each do |idx|
      keys = news_segment.keys
      unless keys[idx].nil?
        news_keywords_array.push keys[idx]
        json_result[keys[idx].to_s] = news_segment[keys[idx]]
      end
    end

    json_result
  end

  def fetch_rss(rss_url)
    feed_content = ""
    
    feed = Feedjira::Feed.fetch_and_parse(rss_url)
    unless feed.nil?
      feed.entries.each do |entry|
        feed_content += entry.title + entry.content
      end
    end

    feed_content
  end
end