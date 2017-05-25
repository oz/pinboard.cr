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
    def last_update : Time
      res = transport.get "/posts/update"
      json = JSON.parse res
      Time::Format.new("%FT%TZ").parse json["update_time"].to_s
    end

    # Get a single Post by URL.
    def get(url : String) : Post | Nil
      res = transport.get "/posts/get", {"url" => url}
      posts = PostResponse.from_json(res).posts
      if posts.empty?
        nil
      else
        posts.first
      end
    end

    # Find posts by tag, or date.
    def get(date : Time, tags : Array(String), meta : Bool = false) : Array(Post)
      res = transport.get "/posts/get", {"dt" => date, "tag" => tags, "meta" => meta}
      PostResponse.from_json(res).posts
    end

    # Returns a list of the user's most recent posts (default: 15).
    def recent : Array(Post)
      res = transport.get "/posts/recent"
      PostResponse.from_json(res).posts
    end

    # Returns a list of the user's most recent posts, filtered by tag.
    def recent(tags : Array = [] of String, count : Int32 = 15) : Array(Post)
      params = {"count" => count} of String => (Int32 | Array(String))
      params["tag"] = tags unless tags.empty?
      res = transport.get "/posts/recent", params
      PostResponse.from_json(res).posts
    end

    # Delete a bookmark by URL.
    def delete(url : String)
      res = transport.get "/posts/delete", {"url" => url}
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    # Add a bookmark, but don't replace if it already existed.
    def add(post : Post) : Bool
      post.replace = false
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    # Add a bookmark, always replacing it.
    def add!(post : Post) : Bool
      post.replace = true
      res = transport.get "/posts/add", post.to_h
      code = JSON.parse(res)["result_code"]
      code == "done"
    end

    def posts
      [] of Post
    end
  end
end
