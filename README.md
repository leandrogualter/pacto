[![Build Status](https://travis-ci.org/thoughtworks/pacto.png)](https://travis-ci.org/thoughtworks/pacto)
[![Code Climate](https://codeclimate.com/github/thoughtworks/pacto.png)](https://codeclimate.com/github/thoughtworks/pacto)
[![Dependency Status](https://gemnasium.com/thoughtworks/pacto.png)](https://gemnasium.com/thoughtworks/pacto)
[![Coverage Status](https://coveralls.io/repos/thoughtworks/pacto/badge.png)](https://coveralls.io/r/thoughtworks/pacto)

# Pacto

Pacto is a Ruby framework to help with [Integration Contract Testing](http://martinfowler.com/articles/integrationContractTest.html).

With Pacto you can:

* [Evolve](https://www.relishapp.com/maxlinc/pacto/docs/evolve) your services with either a [Consumer-Driven Contracts](http://martinfowler.com/articles/consumerDrivenContracts.html) approach or by tracking provider contracts.
* [Generate](https://www.relishapp.com/maxlinc/pacto/docs/generate) a contract from your documentation or sample response.
* [Validate](https://www.relishapp.com/maxlinc/pacto/docs/validate) that a live service still matches the Contract you tested against.
* [Stub](https://www.relishapp.com/maxlinc/pacto/docs/stub) services by letting Pacto creates responses that match a Contract.

Pacto's contract validation capabilities are primilary backed by [json-schema](http://json-schema.org/).  This lets you the power of many assertions that will give detailed and precise error messages.  See the specification for possible assertions.

Pacto's stubbing ability ranges from very simple stubbing to:
* Running a server to test from non-Ruby clients
* Generating random or dynamic data as part of the response
* Following simple patterns to simulate resource collections

It's your choice - do you want simple behavior and strict contracts to focus on contract testing, or rich behavior and looser contracts to create dynamic test doubles for collaboration testing?

Note: Currently, Pacto is only designed to work with JSON services.  See the [[Constraints section]] for further information on what Pacto does not do.

## Contracts

Pacto works by associating a service with a Contract.  The Contract is a JSON description of the service that uses json-schema to describe the response body.  You don't need to write your contracts by hand.  In fact, we recommend generating a Contract from your documentation or a service.  See the [[Generators section]] for options.

A contract is composed of a request that has:

- Method: the method of the HTTP request (e.g. GET, POST, PUT, DELETE);
- Path: the relative path (without host) of the provider's endpoint;
- Headers: headers sent in the HTTP request;
- Params: any data or parameters of the HTTP request (e.g. query string for GET, body for POST).

And a response has that has:

- Status: the HTTP response status code (e.g. 200, 404, 500);
- Headers: the HTTP response headers;
- Body: a JSON Schema defining the expected structure of the HTTP response body.

Below is an example contract for a GET request
to the /hello_world endpoint of a provider:

```json
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
```

## Consumer-Driven Contract Recommendations

If you are using Pacto for Consumer-Driven Contracts, we recommend avoiding the advanced features so you'll test with the strictest Contract possible.  We recommend:

- Do not use templating, let Pacto use the json-generator
- Use strict request matching
- Use multiple contracts for the same service to capture attributes that are required in some situations but not others

The host address is intentionally left out of the request specification so that we can validate a contract against any provider.
It also reinforces the fact that a contract defines the expectation of a consumer, and not the implementation of any specific provider.

## Generators

## Constraints

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
