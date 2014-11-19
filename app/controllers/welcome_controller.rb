class WelcomeController < ApplicationController

  def index
    @api_response = HTTParty.get('http://api.eventful.com/rest/events/search?app_key=7vwHmZm5RvCdSDtN&location=New+York&q=music')

    @all_events = api_response["search"]["events"]["event"].map do |event|
      if event["image"] != nil && event["performers"] != nil
        {event: event["title"], performer: event["performers"]["performer"]["name"], image: event["image"]["url"], venue: event["venue_name"], time: event["start_time"]}
      else
        nil
      end
    end

    @events = @all_events.compact

  end
end




