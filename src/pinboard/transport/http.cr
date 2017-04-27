require "http/params"
require "http/client"
require "time"

require "./base"

module Pinboard
  module Transport
    class HTTP < Base
      BASE_URL = "https://api.pinboard.in/v1"

      property :token

      def initialize(@token = ""); end

      def get(path : String)
        get path, {} of String => String
      end

      def get(path : String, params : Hash(_, _))
        url = build_url(path, params)
        res = ::HTTP::Client.get(url)
        res.body
      end

      def build_url(path : String, params : Hash(_, _)) : String
        params["format"] = "json"
        params["auth_token"] = token
        query = ::HTTP::Params.encode(params)
        "#{BASE_URL}#{path}?#{query}"
      end
    end
  end
end
