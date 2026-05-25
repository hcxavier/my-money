#!/bin/bash

set -e

echo "Generating database migrations..."
venv/bin/python manage.py makemigrations

echo "Applying migrations..."
venv/bin/python manage.py migrate

echo "Running Django test suite..."
venv/bin/python manage.py test --settings=config.settings.testing
