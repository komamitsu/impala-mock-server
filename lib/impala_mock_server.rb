require 'impala'
require "impala_mock_server/version"

module ImpalaMockServer
  class Server
    class MyHandler
      def initialize(opt = {})
        @wait_in_query = opt[:wait_in_query]
        @wait_in_get_state = opt[:wait_in_get_state]
        @wait_in_fetch = opt[:wait_in_fetch]
        @wait_for_result = opt[:wait_for_result]
        @status = opt[:result] ? ::Impala::Protocol::Beeswax::QueryState::RUNNING : ::Impala::Protocol::Beeswax::QueryState::FINISHED
        @result = ::Impala::Protocol::Beeswax::QueryState::FINISHED
        if opt[:result]
          @result = instance_eval("::Impala::Protocol::Beeswax::QueryState::#{opt[:result]}")
        end
      end

      def query(args)
        puts "query: #{args.inspect}"
        sleep @wait_in_query if @wait_in_query

        if @wait_for_result
          @status_changer = Thread.new do
            sleep @wait_for_result
            @status = @result
          end
        end

        ::Impala::Protocol::Beeswax::QueryHandle.new
      end

      def get_state(args)
        puts "get_state: #{args.inspect}"
        sleep @wait_in_get_state if @wait_in_get_state
        @status
      end

      def fetch(*args)
        puts "fetch: #{args.to_s}"
        sleep @wait_in_fetch if @wait_in_fetch
        result = ::Impala::Protocol::Beeswax::Results.new
        result.data = []
        result
      end
    end

    def initialize(opt = {})
      @handler_option = opt
    end

    def run
      transport = Thrift::ServerSocket.new(21000)
      STDOUT.sync = true

      handler = MyHandler.new(@handler_option)
      processor = Impala::Protocol::ImpalaService::Processor.new(handler)

      ss = Thrift::SimpleServer.new(processor, transport)
      ss.serve
    end
  end
end

