require "rack/middleware/query_tracer/version"
require "arproxy"

module Rack
  module Middleware
    class QueryTracer
      def initialize(app, logger = ::Arproxy.logger)
        @app = app
        @logger = logger

        ::Arproxy.configure do |config|
          config.adapter = ActiveRecord::Base.connection.adapter_name.downcase # "mysql2" # A DB Apdapter name which is used in your database.yml
          config.use ProxyImpl, @logger
        end
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        @logger.tagged("QueryTracing") do
          ::Arproxy.enable!
          begin
            if request.filtered_path.blank?
              @app.call(env)
            else
              @logger.tagged(request.filtered_path) do
                @app.call(env)
              end
            end
          ensure
            ::Arproxy.disable!
          end
        end
      end

      class ProxyImpl < ::Arproxy::Base
        def initialize(logger)
          @logger = logger
        end

        def execute(sql, name = nil)
          code_position_tag = "#{caller.select { |n| /\/app\// =~ n }[0].to_s.sub(/^.+?(\/app\/)/, '\1')}"
          do_logging(code_position_tag, sql)
          super(sql, name)
        end

        private

        def do_logging(tag, sql)
          @logger.tagged("QueryTracer") do
            @logger.tagged(tag) do
              @logger.info sql

              case sql
              when /SELECT/, /UPDATE/
                case sql
                when /1=0/
                  @logger.tagged("ALERT") do
                    @logger.info("1=0 QUERY: #{sql}")
                  end
                end
              end
            end
          end
        end

        #TODO
        # def analyzer(sql, name=nil)
        #   case sql
        #   when /SELECT/, /UPDATE/
        #     explain_sql     = "EXPLAIN #{sql}"
        #     _result = super(explain_sql, name)
        #
        #     Rails.logger.tagged("EXPLAIN") do
        #       result = ActiveRecord::Result.new(_result.fields, _result.to_a)
        #       case sql
        #       when /1=0/
        #         Rails.logger.tagged("ALERT") do
        #           Rails.logger.info "1=0 QUERY: #{sql}"
        #         end
        #       end
        #     end
        #   end
        # end
      end
    end
  end
end
