require "json"
require "./post"

module Pinboard
  struct PostList
    include JSON::Serializable

    @[JSON::Field(converter: Pinboard::TIME_CONVERTER)]
    property date : Time

    property user : String
    property posts : Array(Pinboard::Post)
  end
end
