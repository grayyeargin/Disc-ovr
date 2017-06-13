module ArtistHelper


  class Spotifysearch
    attr_reader :artist_id
    def initialize(artist_id, spotify_auth)
      @artist_id = artist_id
      @spotify_auth = spotify_auth
    end

    def grab_unique_albums
      album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums",
       :headers => {"Authorization" => "Bearer #{@spotify_auth['access_token']}"})

      albums_sorted = album_api_response["items"].map do |album|
        {
          album_image: album["images"][0]["url"],
          album_name: album["name"],
          album_id: album["id"] }
      end

      unique_albums = albums_sorted.uniq do |album|
        album[:album_name]
      end

      unique_albums[0..10]


    end
  end





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
      results = configure_client.search(@query+"+music", lang: "en", result_type: "recent", count: 10)

      results.attrs[:statuses].map do |tweet|
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



