module Pacto
  module Stubs
    class BuiltIn

      def initialize
        register_callbacks
      end

      def stub_request! request, response
        path_pattern = request.path.gsub(/\/:\w+/, '/\w+')
        host_pattern = Regexp.quote(request.host)
        stub = WebMock.stub_request(request.method, /#{host_pattern}#{path_pattern}/)
        stub = stub.with(request_details(request)) if Pacto.configuration.strict_matchers
        stub.to_return({
            :status => response.status,
            :headers => response.headers,
            :body => format_body(response.body)
          })
      end

      def request_pattern request
        pattern = WebMock::RequestPattern.new(request.method, "#{request.host}#{request.path}")
        pattern = pattern.with(request_details(request)) if Pacto.configuration.strict_matchers
        pattern
      end

      def reset!
        WebMock.reset!
        WebMock.reset_callbacks
      end

      private

      def register_callbacks
        WebMock.after_request do |request_signature, response|
          contracts = Pacto.contract_for request_signature
          Pacto.configuration.callback.process contracts, request_signature, response
        end
      end

      def format_body(body)
        if body.is_a?(Hash) || body.is_a?(Array)
          body.to_json
        else
          body
        end
      end

      def request_details request
        details = {}
        unless request.params.empty?
          details[webmock_params_key(request)] = request.params
        end
        unless request.headers.empty?
          details[:headers] = request.headers
        end
        details
      end

      def webmock_params_key request
        request.method == :get ? :query : :body
      end
    end
  end
end
