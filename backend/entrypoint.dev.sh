#!/bin/sh

set -e

echo "Waiting for PostgreSQL..."
timeout=60
until pg_isready -h db -p 5432; do
    sleep 1
    timeout=$((timeout - 1))
    
    if [ $timeout -eq 0 ]; then
        echo "PostgreSQL is not available"
        exit 1
    fi
done
echo "PostgreSQL started!"

python manage.py migrate --noinput

exec python manage.py runserver 0.0.0.0:8000

exec "$@"
