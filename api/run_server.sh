#!/bin/bash

set -e

echo "Applying migrations..."
venv/bin/python manage.py makemigrations
venv/bin/python manage.py migrate

echo "Starting My Money development server on http://localhost:3000..."
venv/bin/python manage.py runserver 3000
