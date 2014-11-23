module ArtistHelper
  class Twittersearch
    attr_reader :query
    def initialize(query)
      @query = query.gsub(' ', '')
    end

    def configure_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = "1pBapRIIydVveOjU7TqCQQ8cQ"
        config.consumer_secret = "DrrvWE6uojmXcy1pmpwJ1QRINcbAnEQCF5uiOSgHtD4vFB0Nki"
      end
    end

    def twitter_query
      results = self.configure_client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}+music&count=10", lang: "en", result_type: "recent")

      results[:statuses].map do |tweet|
        {
          text: tweet[:text],
          user_image: tweet[:user][:profile_image_url],
          user: tweet[:user][:name],
          screen_name: tweet[:user][:screen_name],
          created_at: tweet[:created_at],
          retweet_count: tweet[:retweet_count],
          favorite_count: tweet[:favorite_count]
        }
      end
    end

  end
end
