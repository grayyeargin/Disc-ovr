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
      results = configure_client.search(@query+"+music", lang: "en", result_type: "recent")

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




<div class="container">
  <div class="row panel">
    <div class="col-xs-8">
    </div>
    <div class="col-xs-4">
      <div class="tweets-container">
        <% @twitter_results.each do |tweet| %>
        <blockquote class="twitter-tweet">
          <div>
            <div class="tweet-img-left">
              <img src="<%= tweet[:user_image] %>" alt="<%= tweet[:user] %>" class="tweet-image">
            </div>

            <div class="tweet-text-right">
              <strong class="tweet-user"><%= tweet[:user] %></strong>
              <span class="user-screen-name">@<%= tweet[:screen_name] %></span>
              <span>&#8226;</span>
              <span class="user-screen-name"><%= time_ago_in_words(tweet[:created_at]) %> ago</span>
            </br>
            <p><%= tweet[:text] %></p>
          </div>
        </div>
      </blockquote>
      <% end %>
    </div>
  </div>
</div>
