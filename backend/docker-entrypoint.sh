#!/bin/bash
set -e

echo "=== VIZE Resin Backend Booting ==="

# Wait a moment for MySQL to be reachable if needed
if [ -n "$DB_HOST" ] && [ "$DB_CONNECTION" = "mysql" ]; then
    echo "Connecting to MySQL at $DB_HOST..."
    
    # Check if admins table exists, if not import backup
    if ! mysql -h "$DB_HOST" -P "${DB_PORT:-3306}" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" -e "DESCRIBE admins;" > /dev/null 2>&1; then
        echo "Admins table not found. Auto-importing database_backup.sql..."
        mysql -h "$DB_HOST" -P "${DB_PORT:-3306}" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" < database_backup.sql || true
        echo "Database imported successfully!"
    else
        echo "Database already initialized."
    fi
fi

# Ensure storage and cache directories exist and are writable
mkdir -p storage/app storage/framework/cache storage/framework/sessions storage/framework/views bootstrap/cache
chmod -R 777 storage bootstrap/cache
touch storage/installed

# Clear any stale cached config/routes
php artisan config:clear || true
php artisan view:clear || true

# Ensure raw code errors are shown in debug mode
export APP_DEBUG=true

echo "Starting Laravel server on port ${PORT:-8000}..."
exec php artisan serve --host=0.0.0.0 --port="${PORT:-8000}"
