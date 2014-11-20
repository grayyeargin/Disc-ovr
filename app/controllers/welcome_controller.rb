class WelcomeController < ApplicationController

  def index
    api_response = HTTParty.get('http://api.eventful.com/rest/events/search?app_key=7vwHmZm5RvCdSDtN&location=New+York&q=music&c=concert&page_size=20')

    @all_events = api_response["search"]["events"]["event"].map do |event|
      if !event["image"].nil? && !event["performers"].nil? && !event["performers"]["performer"].is_a?(Array) && !event["venue_name"].nil? && !event["start_time"].nil?
        {title: event["title"], performer: event["performers"]["performer"]["name"], image: event["image"]["medium"]["url"], venue: event["venue_name"], time: event["start_time"]}
      else
        nil
      end
    end

    @events = @all_events.compact

  end
end

