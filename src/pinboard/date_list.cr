require "json"

module Pinboard
  struct DateList
    include JSON::Serializable
    property user : String

    property tag : String
    property dates : Hash(String, String)
  end
end
