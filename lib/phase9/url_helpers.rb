module Phase9
  module URLHelpers
    def link_to(title, path)
      "<a href=#{path}>#{title}</a>"
    end

    def button_to(title, path, options = {})
      form = "<form action='path' method='POST'>" +
      if options[:method]
        form += "<input type='hidden' method='#{options[:method]}''>"
      end
      form += "<input type='submit' value='#{title}'>"
      form += "</form>"
    end
  end
end
