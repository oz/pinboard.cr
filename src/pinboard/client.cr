require "time"

require "./post"
require "./transport"

module Pinboard
  class Client
    property :transport

    def initialize(token : String, @transport : Transport::Base = Transport::HTTP.new)
      @transport.token = token
    end

    # Returns the most recent time a bookmark was added, updated or deleted.
    def update : Time
      res = transport.get("/posts/update")
      json = JSON.parse(res)
      Time::Format.new("%FT%TZ").parse json["update_time"].to_s
    end

    # Get a single Post by URL
    def get(url : String) : Post
      res = transport.get("/posts/get", {"url" => url})
      PostResponse.from_json(res).posts.first
    end

    # Find posts by tag, or date.
    def get(date : Time, tags : String, meta : Bool = false)
      nil
    end

    def posts
      [] of Post
    end
  end
end
