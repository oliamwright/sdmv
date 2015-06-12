namespace :rss do
  desc "Rake task to get News feed"

  task :update_news => :environment do

    news_objects = NewsObject.all
    news_objects.each do |news|
      feed_content = ""
    
      unless news.rss.nil?
        feed = Feedjira::Feed.fetch_and_parse(news.rss)
        unless feed.nil?
          feed.entries.each do |entry|
            feed_content += entry.title + entry.content
          end
        end
      end

      news.update_attributes :news => feed_content
    end
  end
end