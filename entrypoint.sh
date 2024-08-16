#!/bin/sh
set -e

# Wait for the database to be ready
/app/wait-for-it.sh db:3306 --timeout=30 --strict -- echo "Database is up"

# Run any migrations (if required)
flask db upgrade

# Start the Flask application
exec flask run --host=0.0.0.0 --port=5000
