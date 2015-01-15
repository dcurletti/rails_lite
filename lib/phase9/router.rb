require_relative '../phase6/router'
require_relative './url_helpers'

module Phase9
  class Route < Phase6::Route
    def initialize(pattern, http_method, controller_class, action_name)
      super
      add_url_helpers
    end

    def add_url_helpers
      case http_method
      when :edit
        
    end


    private
  end


  class Router < Phase6::Router
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(
        pattern,
        method,
        controller_class,
        action_name
      )
    end
  end
end
