require 'byebug'
module Phase6
  class Route
	attr_reader :pattern, :http_method, :controller_class, :action_name

	def initialize(pattern, http_method, controller_class, action_name)
		@pattern = pattern
		@http_method = http_method
		@controller_class = controller_class
		@action_name = action_name
	end

	# checks if pattern matches path and method matches request method
	def matches?(req)
      (http_method == req.request_method.downcase.to_sym) && !!(pattern =~ req.path)
	end

	# use pattern to pull out route params (save for later?)
	# instantiate controller and call controller action
	def run(req, res)
		## Route matching
		match_data = @pattern.match(req.path)
		params = {}
		match_data.names.each do |name|
			params[name] = match_data[name]
		end

		@controller = @controller_class.new(req, res, params)
		@controller.invoke_action(@action_name)
	end
  end

  class Router
	attr_reader :routes

	def initialize
		@routes = []
	end

	# simply adds a new route to the list of routes
	def add_route(pattern, method, controller_class, action_name)
		new_route = Route.new(pattern, method, controller_class, action_name)
		@routes << new_route
	end

	# evaluate the proc in the context of the instance
	# for syntactic sugar :)
	def draw(&proc)
		instance_eval(&proc)
	end

	# make each of these methods that
	# when called add route
	[:get, :post, :put, :delete].each do |http_method|
		define_method(http_method) do |pattern, controller_class, action_name|
			add_route(pattern, http_method, controller_class, action_name)
		end
	end

	# should return the route that matches this request
	def match(req)
		match = []
		# debugger
		@routes.each {|route| match << route if route.matches?(req)}
		match.empty? ? nil : match.first
	end

	# either throw 404 or call run on a matched route
	def run(req, res)

		route = match(req) 
		if route.nil?
			res.status = 404
		else
			route.run(req, res)
		end
	end
  end
end
