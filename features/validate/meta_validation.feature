Feature: Meta-validation

  Meta-validation ensures that a Contract file matches the Contract format.  It does not validation actual responses, just the Contract itself.

  You can easily do meta-validation with the Rake task pacto:meta_validate, or programmatically.

  Background:
    Given a file named "contracts/my_contract.json" with:
      """
          {
          "request": {
            "method": "GET",    
            "path": "/hello_world",
            "headers": {
              "Accept": "application/json"
            },
            "params": {}
          },

          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "body": {
              "description": "A simple response",
              "type": "object",
              "properties": {
                "message": {
                  "type": "string"
                }
              }
            }
          }
        }
      """

  Scenario: Meta-validation via a rake task
    When I successfully run `bundle exec rake pacto:meta_validate['tmp/aruba/contracts/my_contract.json']`
    Then the output should contain "All contracts successfully meta-validated"

  Scenario: Programmatic meta-validation
    Given a file named "meta_validate.rb" with:
    """ruby
    require 'pacto'
    Pacto.validate_contract 'contracts/my_contract.json'
    """
    When I successfully run `bundle exec ruby meta_validate.rb`
    Then the output should contain "All contracts successfully meta-validated"

# The tests from here down should probably be specs instead of relish

  Scenario: Meta-validation of an invalid contract
    Given a file named "contracts/my_contract.json" with:
    """
    {"request": "yes"}
    """
    When I run `bundle exec rake pacto:meta_validate['tmp/aruba/contracts/my_contract.json']`
    Then the exit status should be 1
    And the output should contain "did not match the following type"


  Scenario: Meta-validation of a contract with empty request and response
    Given a file named "contracts/my_contract.json" with:
    """
    {"request": {}, "response": {}}
    """
    When I run `bundle exec rake pacto:meta_validate['tmp/aruba/contracts/my_contract.json']`
    Then the exit status should be 1
    And the output should contain "did not contain a required property"

  Scenario: Meta-validation of a contracts response body
    Given a file named "contracts/my_contract.json" with:
    """
        {
        "request": {
          "method": "GET",
          "path": "/hello_world"
        },

        "response": {
          "status": 200,
          "body": {
            "required": "anystring"
            }
          }
        }
    """
    When I run `bundle exec rake pacto:meta_validate['tmp/aruba/contracts/my_contract.json']`
    Then the exit status should be 1
    And the output should contain "did not match the following type"
