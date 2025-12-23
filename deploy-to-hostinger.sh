#!/bin/bash

# Hostinger Shared Hosting Deployment Script
# This script prepares your Laravel application for deployment

echo "=========================================="
echo "Hostinger Deployment Preparation Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found. Creating from .env.example if available...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}.env file created. Please configure it before deployment.${NC}"
    else
        echo -e "${RED}Error: .env.example not found. Please create .env manually.${NC}"
        exit 1
    fi
fi

# Install/Update dependencies
echo -e "${GREEN}Installing production dependencies...${NC}"
composer install --optimize-autoloader --no-dev --no-interaction

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Composer install failed.${NC}"
    exit 1
fi

# Generate application key if not set
echo -e "${GREEN}Checking application key...${NC}"
php artisan key:generate --force

# Clear and cache configuration
echo -e "${GREEN}Optimizing application...${NC}"
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create storage link
echo -e "${GREEN}Creating storage symlink...${NC}"
php artisan storage:link

# Set permissions (for local testing)
echo -e "${GREEN}Setting file permissions...${NC}"
chmod -R 775 storage bootstrap/cache 2>/dev/null || echo -e "${YELLOW}Note: Permission setting may need to be done on server${NC}"

echo ""
echo -e "${GREEN}=========================================="
echo "Deployment Preparation Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Review and update .env file with production settings"
echo "2. Upload files to Hostinger (excluding .git, node_modules, etc.)"
echo "3. Set file permissions on server (storage: 775, bootstrap/cache: 775)"
echo "4. Run migrations: php artisan migrate --force"
echo "5. Configure cron jobs in Hostinger hPanel"
echo ""
echo "See DEPLOYMENT_GUIDE.md for detailed instructions."

