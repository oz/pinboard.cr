require "json"
require "time"

module Pinboard
  TIME_FORMAT = "%FT%TZ"
  TIME_CONVERTER = Time::Format.new(TIME_FORMAT)

  struct Post
    property url,
             title,
             description,
             meta,
             hash,
             time,
             tags

    property? toread : Bool = false
    property? shared : Bool = true
    property? replace : Bool = true

    JSON.mapping({
      url:         {type: String, key: "href"},
      title:       {type: String, key: "description"},
      description: {type: String, key: "extended"},
      meta:        String,
      hash:        String,
      time:        {type: Time, converter: TIME_CONVERTER},
      shared:      {type: Bool, converter: YesNoConverter},
      toread:      {type: Bool, converter: YesNoConverter},
      tags:        {type: Array(String), converter: TagConverter},
    })

    def initialize(
      url : String,
      title : String,
      description : String = "",
      time : Time = Time.utc_now,
      shared : Bool = true,
      toread : Bool = false,
      tags : Array(String) = [] of String
    )
      @url = url
      @title = title
      @description = description
      @time = time
      @shared = shared
      @toread = toread
      @tags = tags
      @meta = ""
      @hash = ""
    end

    # Convert to a Hash for querying.
    # @return [Hash]
    def to_h
      hash = {
        "url" => url,
        "description" => title,
        "dt" => time.to_s(TIME_FORMAT),
        "shared" => shared? ? "yes" : "no",
        "toread" => toread? ? "yes" : "no",
        "replace" => replace? ? "yes" : "no"
      }
      hash["extended"] = description if description != ""
      hash["tags"] = tags.join(",") unless tags.empty?
      hash
    end
  end

  private module YesNoConverter
    def self.from_json(value : JSON::PullParser) : Bool
      value.read_string == "yes"
    end
  end

  private module TagConverter
    def self.from_json(value : JSON::PullParser) : Array(String)
      value.read_string.split(" ")
    end
  end

  struct PostResponse
    JSON.mapping({
      date: { type: Time, converter: TIME_CONVERTER },
      user: String,
      posts: Array(Post)
    })
  end
end
