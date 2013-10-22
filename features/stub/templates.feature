Feature: Templating

  If you want to create more dynamic stubs, you can use Pacto templating.  Currently the only supported templating mechanism is to use ERB in the "default" attributes of the json-schema.
  
  Current both ERB pre-processing or post-processing are supported.  Make sure you disable pre-processing if you want to use post-processing:
  ```ruby
    Pacto.configure do |config|
      config.preprocessor = nil
      config.postprocessor = Pacto::ERBProcessor.new
    end
  ```

  Background:
    Given Pacto is configured with:
      """ruby
      Pacto.configure do |config|
        config.preprocessor = nil
        config.postprocessor = Pacto::ERBProcessor.new
      end
      Pacto.load_all 'contracts', 'http://example.com', :default
      Pacto.use :default
      """
    Given a file named "contracts/template.json" with:
      """json
      {
        "request": {
          "method": "GET",
          "path": "/hello",
          "headers": {
            "Accept": "application/json"
          },
          "params": {}
        },

        "response": {
          "status": 200,
          "headers": { "Content-Type": "application/json" },
          "body": {
            "type": "object",
            "required": true,
            "properties": {
              "message": { "type": "string", "required": true,
                "default": "<%= 'Hello, world!'.reverse %>"
              }
            }
          }
        }
      }
      """

  Scenario: ERB Template
    When I request "http://example.com/hello"
    Then the output should contain:
      """
      {"message":"!dlrow ,olleH"}
      """
