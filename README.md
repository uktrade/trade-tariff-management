[![Maintainability](https://api.codeclimate.com/v1/badges/4a91c7c33582ec9ea2fd/maintainability)](https://codeclimate.com/github/uktrade/trade-tariff-management/maintainability)
[![CircleCI](https://circleci.com/gh/uktrade/trade-tariff-management.svg?style=svg)](https://circleci.com/gh/uktrade/trade-tariff-management)

# Trade Tariff Management

## Development

1. Update `.env` file with valid data (or copy .sample.env)
2. Ask for a database backup file.

## Using Docker
1. Install and run Docker from [https://docs.docker.com/install/](https://docs.docker.com/install/)
2. Update `.env` values with the ones below
```
    REDIS_URL=redis://redis:6379/0
    DATABASE_HOST=db
    DATABASE_USER=postgres
    DATABASE_PASS=
```
3. Run the below command inside root folder:
```
    docker-compose run tariffs  . --force --no-deps --database=postgresql
```
4. Run:
```
    docker-compose up
```

5. <a name="5"></a> Run the below command to copy your database dump file inside the db container:
```
     docker cp /Absolute_Path_To_File/tariff_management_development.dump trade-tariff-management_db_1:/
```
6. <a name="6"></a> Import database
    1. Enter the database container
    ```
        docker exec -i -t trade-tariff-management_db_1  /bin/bash
    ```

    2. Import the database that we have copied before
    ```
        psql -U postgres -d tariff_management_development < tariff_management_development.dump
    ```

    3. Exit container
    ```
        exit
    ```
7. <a name="7"></a> Run the below command to drop an event trigger that is not needed in development and prevents app from running. This step can be remove in the future.
```
    docker exec trade-tariff-management_db_1 psql -U postgres -c "drop event trigger reassign_owned;"
```

More details can be found at [https://docs.docker.com/compose/rails/](https://docs.docker.com/compose/rails/)

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
4. Migrate database
```
    docker exec trade-tariff-management_tariffs_1 rake db:migrate
```
5. Run the below command to create databases:
```
    docker exec trade-tariff-management_tariffs_1 rake db:create
```

### Docker troubleshooting
1. If you end up in an infinity loop of `"Postgres is unavailable - sleeping"` then stop and restart
the containers

    ```
        docker-compose down
    ```
    ```
        docker-compose up
    ```

2. If you get an `psql: FATAL: the database system is starting up` error message, it means that your db is corrupted.
An easy solution would be:

    2.1.
        Stop all the containers

        ```
            docker-compose down
        ```
    2.2. Delete `tmp\db` folder from the app root folder

    2.3. Re-build the containers:

        ```
            docker-compose build
        ```
    2.4. Assuming that you have found a better copy of the db repeat steps [5](#5), [6](#6) and [7](#7)

3. Container names are based on your app folder name. We are assuming that you are using the default
    when you cloned the repo. If for some reason you have renamed the folder, you will need to amend all the
    above references to reflect that. For example: `trade-tariff-management_tariffs_1` should be renamed to
    `MY_CUSTOM_APP_FOLDER_NAME_tariffs_1`

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
