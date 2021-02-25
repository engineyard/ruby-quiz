#!/bin/bash

# Examples of how to render .yml files from env vars before starting the app itself.

# Render database.yml from env vars
#erb -T - .eyk/config/database.yml.erb > config/database.yml

# Render secrets.yml.erb
#erb -T - .eyk/config/secrets.yml.erb > config/secrets.yml

# Render sidekiq configuration
#erb -T - .eyk/config/sidekiq.yml.erb > config/sidekiq.yml