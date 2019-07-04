[![Maintainability](https://api.codeclimate.com/v1/badges/4a91c7c33582ec9ea2fd/maintainability)](https://codeclimate.com/github/uktrade/trade-tariff-management/maintainability)

# Trade Tariff Management

## Development

1. Update `.env` file with valid data (or copy .sample.env)
2. Ask for a copy of database dump file.

## Using Docker
1. Install and run Docker from [https://docs.docker.com/install/](https://docs.docker.com/install/)
2. Run the below command inside root folder:
```
    docker-compose run tariffs  . --force --no-deps --database=postgresql
```
3. Run:
```
    docker-compose up
```
4. Run the below command to create databases:
```
    docker-compose run tariffs rake db:create
```
5. Run the below command to copy your database dump file inside the db container:
```
     docker cp /Absolute_Path_To_File/tariff_management_development.dump trade-tariff-management_db_1:/
```
6. Depending the format of your dump file run either one of the below commands for
  importing data to the db
```
    docker exec trade-tariff-management_db_1 psql -U postgres -d tariff_management_development /tariff_management_development.dump
```

```
    docker exec trade-tariff-management_db_1 pg_restore -U postgres -d tariff_management_development /tariff_management_development.dump
```

### Docker help
1. If you want to stop the containers run:
```
    docker-compose down
```
2. If you want to start the containers run:
```
    docker-compose up
```
3. If you want to re-build containers run:
```
    docker-compose build
```

## Manual Set up

### Dependencies

  - Ruby
  - Postgresql
  - Redis (must be running for search)
  - Chrome (for integration specs)

### Setup

1. Setup your environment.

    bin/setup

2. Start Foreman.

    foreman start

3. Verify that the app is up and running.

    open http://localhost:3020/healthcheck

## Test

1. RAILS_ENV=test bundle exec rake db:drop db:create db:structure:load

2. RAILS_ENV=test bundle exec rspec spec/

### CI

CI for this project is provided by CircleCI: https://circleci.com/gh/uktrade/trade-tariff-management.


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

Please check out the [Contributing guide](https://github.com/uktrade/trade-tariff-management/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/uktrade/trade-tariff-management/blob/master/LICENCE.txt)
