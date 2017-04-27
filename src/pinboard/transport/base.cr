module Pinboard
  module Transport
    abstract class Base
      abstract def get(path : String)
      abstract def get(path : String, params : Hash(_, _))
    end
  end
end
