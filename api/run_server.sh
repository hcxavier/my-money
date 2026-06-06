#!/bin/bash

set -e

echo "Applying migrations..."
venv/bin/python manage.py makemigrations
venv/bin/python manage.py migrate

echo "Starting My Money development server on http://localhost:8000..."
venv/bin/python manage.py runserver 0.0.0.0:8000
