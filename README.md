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

### CI

CI for this project is provided by GitLab CI.

If you'd like to update the CI configuration you can test changes locally using
the GitLab Runner (to avoid having to continually push changes then adjust):

1. Install [Docker](https://docs.docker.com/install/)
  - `brew cask install docker` on MacOS
1. Install [GitLab Runner](https://docs.gitlab.com/runner/install/index.html)
  - `brew install gitlab-runner` on MacOS
1. Run `gitlab-runner exec docker test`
  - N.B. Any changes aside from edits to `.gitlab-ci.yml` need to be committed
    to take effect

## Deployment

We deploy using the DIT CI Deployment pipeline to manage deployments:
https://github.com/uktrade/ci-pipeline-config
The Procfile specifies what will run on the PaaS https://github.com/uktrade/trade-tariff-management/blob/master/Procfile

NB: In the newer Diego architecture from CloudFoundry, no-route skips creating and binding a route for the app, but does not specify which type of health check to perform. If your app does not listen on a port, for example the sidekiq worker, then it does not satisfy the port-based health check and Cloud Foundry marks it as crashed. To prevent this, disable the port-based health check with cf set-health-check APP_NAME none.

## Notes

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

### Environment variables

- `XML_ENVELOPE_ID_OFFSET_YEAR_<YYYY>` - allows the XML envelope ID to be
  started from a value other than one. This intended to allow the sequence to
  follow-on from the ID reached by other system before cut-over.

## Contributing

Please check out the [Contributing guide](https://github.com/bitzesty/trade-tariff-management/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/bitzesty/trade-tariff-management/blob/master/LICENCE.txt)
