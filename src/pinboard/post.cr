require "json"
require "time"

module Pinboard
  # JSON serialization helpers used in both Post and PostList
  TIME_FORMAT    = "%FT%TZ"
  TIME_CONVERTER = Time::Format.new(TIME_FORMAT)

  struct Post
    include JSON::Serializable

    @[JSON::Field(key: "href")]
    property url : String

    @[JSON::Field(key: "description")]
    property title : String

    @[JSON::Field(key: "extended")]
    property description : String

    @[JSON::Field(converter: Pinboard::TIME_CONVERTER)]
    property time : Time

    @[JSON::Field(converter: Pinboard::TagConverter)]
    property tags : Array(String)

    @[JSON::Field(converter: Pinboard::YesNoConverter)]
    property? toread : Bool = false

    @[JSON::Field(converter: Pinboard::YesNoConverter)]
    property? shared : Bool = true

    property? replace : Bool = true
    property meta : String
    property hash : String

    def initialize(
      @url : String,
      @title : String,
      @description : String = "",
      @time : Time = Time.utc,
      @shared : Bool = true,
      @toread : Bool = false,
      @tags : Array(String) = [] of String
    )
      @meta = ""
      @hash = ""
    end

    # Convert to a Hash for querying.
    # @return [Hash]
    def to_h
      hash = {
        "url"         => url,
        "description" => title,
        "dt"          => time.to_s(TIME_FORMAT),
        "shared"      => shared? ? "yes" : "no",
        "toread"      => toread? ? "yes" : "no",
        "replace"     => replace? ? "yes" : "no",
      }
      hash["extended"] = description if description != ""
      hash["tags"] = tags.join(",") unless tags.empty?
      hash
    end
  end

  module YesNoConverter
    def self.from_json(value : JSON::PullParser) : Bool
      value.read_string == "yes"
    end
  end

  module TagConverter
    def self.from_json(value : JSON::PullParser) : Array(String)
      value.read_string.split(" ")
    end
  end
end
