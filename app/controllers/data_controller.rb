class DataController < ApplicationController

  attr_accessor :news, 
                :social, 
                :exclusion

  # when change news value
  def news
    if @news == params[:news] && @exclusion == params[:exclusion]
      render :json => {errors: "Could not retrieve candidate profile."}, status: :unprocessible_entity and return
    end

    @exclusion = params[:exclusion].nil? ? "" : params[:exclusion]
    @news = params[:news]

    exclusion_list = @exclusion.split(/,/)

    news_segment = Hash.new(0)
    @news.split(/ /).each do |word|
      # check exclusion array contains a word
      unless exclusion_list.include? word
        news_segment[word] += 1
      end
    end

    # Sort news hash by word count
    news_segment = Hash[news_segment.sort_by{|k, v| v}.reverse]

    json_result = {}
    (0..4).each do |idx|
      keys = news_segment.keys
      unless keys[idx].nil?
        json_result[keys[idx].to_s] = news_segment[keys[idx]]
      end
    end
    render :json => {
      :success => true, 
      :result => json_result.to_json
    }, status: :created and return
  end
end