module Pinboard
  module Transport
    module QueryParams
      def self.encode(h : Hash(_, _)) : Hash(String, String)
        encoded = {} of String => String
        h.each do |key, value|
          encoded[key] = encode_value value unless value.nil?
        end
        encoded
      end

      private def self.encode_value(value : Array(String)) : String
        value.join ","
      end

      private def self.encode_value(value : Bool) : String
        value ? "yes" : "no"
      end

      private def self.encode_value(value : _) : String
        value.to_s
      end
    end
  end
end
