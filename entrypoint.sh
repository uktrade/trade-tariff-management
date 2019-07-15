#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait-for-postgres to be available
host="management_db"

until psql -h "$host" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 5
done
>&2 echo "Postgres is up - executing command"

# Then migrate
rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"