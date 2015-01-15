require 'json'
require 'webrick'
require 'byebug'
module Phase8
  class Flash
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |c| c.name == "_rails_lite_app_flash" }
      @data = cookie.nil? ? {} : JSON.parse(cookie.value)
      # if @data.nil?
      #   @data = @data_now
      # elsif !@data_now.nil?
      #   @data.merge(@data_now)
      # end
      @data_now = {}
    end

    def [](key)
      now[key] || @data[key.to_s]
    end

    def []=(key, val)
      @data[key] = val
    end

    def now
      @data_now
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      res.cookies << WEBrick::Cookie.new("_rails_lite_app_flash", @data.to_json)
    end
  end
end
