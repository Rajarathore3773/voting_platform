#!/usr/bin/env bash
set -e

echo "Starting Voting Platform..."

# Wait for database to be ready
echo "Waiting for database to be ready..."
until bundle exec rake db:version 2>/dev/null; do
  echo "Database not ready, waiting..."
  sleep 2
done

# Run migrations if needed
echo "Running database migrations..."
bundle exec rake db:migrate

# Start the Rails server
echo "Starting Rails server..."
exec bundle exec puma -C config/puma.rb 