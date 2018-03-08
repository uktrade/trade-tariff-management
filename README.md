[![CircleCI](https://circleci.com/gh/bitzesty/trade-tariff-management/tree/master.svg?style=svg&circle-token=b8a9dd7a0291f0c6c5558c6c5240be5908dbb649)](https://circleci.com/gh/bitzesty/trade-tariff-management/tree/master)
[![Code Climate](https://codeclimate.com/github/bitzesty/trade-tariff-management/badges/gpa.svg)](https://codeclimate.com/github/bitzesty/trade-tariff-management)

# Trade Tariff Management

## Useful Documents

[TARIC3-Interface Data Specification.pdf](https://drive.google.com/file/d/0B9fpaFVNqUf1dnFTVmJTS25hR28/view)

[20180206 System Functions - WIP.pdf](https://bitzesty.slack.com/messages/C917SKV9V/files/F94T9DJ49/)

[XML DOCS - TARIC3 IDS Technical Message Exchange Specification](https://docs.google.com/document/d/1H5GOHECppTmUXXF444m-0Qce5N85TMFJCVWqYafbCjA/edit?usp=drive_web&ouid=113725455905915898903)

[WIFERAMES of TARIFFSALPHA at uktrade.atlassian.net](https://uktrade.atlassian.net/wiki/spaces/TARIFFSALPHA/pages/294846783/Screen+Concepts)

[Technical documentation for GOV.UK PaaS - all about deployment](https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas)

[HOW TO GET AND LOAD DB DUMP](https://github.com/alphagov/paas-cf-conduit/blob/master/README.md)

## Development

### Dependencies

  - Ruby
  - Postgresql
  - Redis

### Setup

1. Setup your environment.

    bin/setup

2. Update `.env` file with valid data.

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
