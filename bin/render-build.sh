#!/usr/bin/env bash
# exit on error
set -o errexit

# Set a secret key base for all Rails operations if not already set
export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(rails secret)}

echo "Using SECRET_KEY_BASE: ${SECRET_KEY_BASE:0:20}..."

bundle install

# Precompile assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations
bundle exec rake db:migrate 