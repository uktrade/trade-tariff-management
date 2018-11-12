[![Maintainability](https://api.codeclimate.com/v1/badges/4a91c7c33582ec9ea2fd/maintainability)](https://codeclimate.com/github/uktrade/trade-tariff-management/maintainability)

# Trade Tariff Management

## Development

### Dependencies

  - Ruby
  - Postgresql
  - Redis (must be running for search)
  - Chrome (for integration specs)

### Setup

1. Setup your environment.

    bin/setup

2. Update `.env` file with valid data (or copy .env.test)

3. Start Foreman.

    foreman start

4. Verify that the app is up and running.

    open http://localhost:3020/healthcheck

## Test

1. RAILS_ENV=test bundle exec rake db:drop db:create db:structure:load

2. RAILS_ENV=test bundle exec rspec spec/

## Deployment

We deploy to cloud foundry, so you need to have the CLI installed, and the following [cf plugin](https://docs.cloudfoundry.org/cf-cli/use-cli-plugins.html) installed:

Download the plugin for your os:  https://github.com/contraband/autopilot/releases

    chmod +x autopilot-(YOUR_OS)
    cf install-plugin autopilot-(YOUR_OS)

Set the following ENV variables:
* CF_USER
* CF_PASSWORD
* CF_ORG
* CF_SPACE
* CF_APP
* CF_APP_WORKER
* HEALTHCHECK_URL
* SLACK_CHANNEL
* SLACK_WEBHOOK

Then run

    ./bin/deploy

NB: In the newer Diego architecture from CloudFoundry, no-route skips creating and binding a route for the app, but does not specify which type of health check to perform. If your app does not listen on a port, for example the sidekiq worker, then it does not satisfy the port-based health check and Cloud Foundry marks it as crashed. To prevent this, disable the port-based health check with cf set-health-check APP_NAME none.

## Notes

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

## Contributing

Please check out the [Contributing guide](https://github.com/bitzesty/trade-tariff-management/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/bitzesty/trade-tariff-management/blob/master/LICENCE.txt)
