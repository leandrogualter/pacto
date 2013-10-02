module Pacto
  class Contract
    attr_reader :values
    attr_reader :response

    def initialize(request, response, file = nil)
      @request = request
      @response = response
      @file = file
      @provider = Pacto.configuration.provider
    end

    def stub_contract! values = {}
      @values = values
      @stub = @provider.stub_request!(@request, stub_response) unless @request.nil?
    end

    def validate(response_gotten = provider_response, opt = {})
      @response.validate(response_gotten, opt)
    end

    def matches? request_signature
      if @stub
        @stub.matches? request_signature
      else
        @provider.request_pattern(@request).matches? request_signature
      end
    end

    private

    def provider_response
      @request.execute
    end

    def stub_response
      @response.instantiate
    end

  end
end
