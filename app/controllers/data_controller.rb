class DataController < ApplicationController
  skip_before_action :verify_authenticity_token

  # When news value is changed, extract top 5 keywords and calculate simularity
  # When exclusion value is changed, extract top 5 keywords and calculate simularity
  def news
    exclusion = params[:exclusion].nil? ? "" : params[:exclusion]
    news = params[:news].nil? ? "" : params[:news]

    exclusion_list = exclusion.split(/,/)
    unless exclusion_list.nil?
      exclusion_list.each(&:strip)
    end

    news_segment = Hash.new(0)
    news.split(/ /).each do |word|
      # check exclusion array contains a word
      unless exclusion_list.include? word
        news_segment[word] += 1
      end
    end

    # Sort news hash by word count
    news_segment = Hash[news_segment.sort_by{|k, v| v}.reverse]

    news_keywords_array = []
    json_result = {}
    (0..4).each do |idx|
      keys = news_segment.keys
      unless keys[idx].nil?
        news_keywords_array.push keys[idx]
        json_result[keys[idx].to_s] = news_segment[keys[idx]]
      end
    end
    news_keywords = news_keywords_array.map(&:inspect).join(' ')

    similarity_obj = SimilarityCalculator.new
    similarity_obj.news = news
    similarity_obj.news_keywords = news_keywords
    similarity_obj.exclusion = exclusion

    render :json => {
      :success => true, 
      :result => json_result.to_json,
      :news_keywords => news_keywords_array.to_json,
      :similarity => calc_similarity_keywords
    }, status: :created and return
  end

  # when change social value, extract top 5 keywords and calculate simularity
  def social

    social = params[:social]

    social_segment = Hash.new(0)
    social.split(/,/).each(&:strip!).each do |word|
      social_segment[word] += 1
    end

    # Sort social hash by word count
    social_segment = Hash[social_segment.sort_by{|k, v| v}.reverse]

    social_keywords_array = []
    json_result = {}
    (0..4).each do |idx|
      keys = social_segment.keys
      unless keys[idx].nil?
        social_keywords_array.push keys[idx]
        json_result[keys[idx].to_s] = social_segment[keys[idx]]
      end
    end

    similarity_obj = SimilarityCalculator.new
    similarity_obj.social = social
    similarity_obj.social_keywords = social_keywords_array.map(&:inspect).join(' ')

    render :json => {
      :success => true, 
      :result => json_result.to_json,
      :social_keywords => social_keywords_array.to_json,
      :similarity => calc_similarity_keywords
    }, status: :created and return
  end

  # Calculate similarity between news and social keywords
  # If news/social keywords are empty, return 0
  def calc_similarity_keywords

    if SimilarityCalculator.news_keywords.blank? || SimilarityCalculator.social_keywords.blank?
      return 0
    end

    same_count = 0
    news_keywords_array = SimilarityCalculator.news_keywords.split(/ /).map(&:downcase)
    social_keywords_array = SimilarityCalculator.social_keywords.split(/ /).map(&:downcase)
    news_keywords_array.each do |n_k|
      if social_keywords_array.include? n_k
        same_count += 1
      end
    end

    # Return the value in percentage
    "%1.f" % ((same_count.to_f / news_keywords_array.length.to_f) * 100)
  end

end