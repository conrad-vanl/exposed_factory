module Rack
  class ExposedFactory

    def initialize(app, options={})
      default_options = {
        :path           => ".exposed-factory",
        :build_path     => "/build",
        :setup_path     => "/setup",

        :db_setup       => lambda { DatabaseCleaner.clean_with :truncation; DatabaseCleaner.strategy = :truncation },
        :db_before      => lambda { DatabaseCleaner.start },
        :db_clean       => lambda { DatabaseCleaner.clean },

        :factory_setup  => lambda { }, # FactoryGirl.find_definitions   },
        :factory_build  => lambda { |type, args| FactoryGirl.create(type, args).as_json }
      }

      @app, @options = app, default_options.merge(options)
    end

    def call(env)
      path = env['PATH_INFO']

      if path.start_with?("/"+@options[:path]+@options[:build_path])
        return build(env)
      elsif path.start_with?("/"+@options[:path]+@options[:setup_path])
        return setup(env)
      elsif path.start_with?("/"+@options[:path])
        return [200, {}, ["Exposed Factory standing by"]]
      else
        @app.call env
      end
    end


    protected

    def setup(env)
      @options[:db_setup].call()
      @options[:db_before].call()
      @options[:factory_setup].call()
      [200, {}, []]
    end

    def build(env)
      req = Rack::Request.new(env)
      params = JSON.parse(req.body.read)

      @options[:db_clean].call()
      @options[:db_before].call()

      built = {}
      params.each do |label, payload|
        built[label] = @options[:factory_build].call(payload[0].to_sym, payload[1]) 
      end
 
      res = ""
      if JSON.method_defined? :encode
        res = JSON.encode(built)
      else
        res = JSON.generate(built, quirks_mode: true)
      end
      [200, {}, [res]]
    end


  end
end