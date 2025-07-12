#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Set a temporary secret key base for asset precompilation if not already set
export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(rails secret)}

bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate 