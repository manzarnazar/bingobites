# Quick Deployment Checklist

Use this checklist to ensure you don't miss any steps during deployment.

## Pre-Deployment (Local)

- [ ] Run `composer install --optimize-autoloader --no-dev`
- [ ] Generate application key: `php artisan key:generate`
- [ ] Optimize application: `php artisan config:cache && php artisan route:cache && php artisan view:cache`
- [ ] Test application locally
- [ ] Prepare `.env` file with production settings

## File Upload

- [ ] Upload all files to Hostinger (via FTP/SFTP or File Manager)
- [ ] Exclude: `.git`, `.gitignore`, `node_modules`, `.env` (create on server)
- [ ] Verify `vendor` folder is uploaded
- [ ] Verify `storage` folder is uploaded

## Server Configuration

- [ ] Create `.env` file on server with correct settings
- [ ] Set PHP version to 8.2+ in Hostinger hPanel
- [ ] Enable required PHP extensions (curl, gd, mbstring, openssl, pdo_mysql, zip)
- [ ] Set file permissions:
  - [ ] `storage` folder: 775
  - [ ] `bootstrap/cache` folder: 775
- [ ] Create storage symlink: `php artisan storage:link` (or manually)

## Database Setup

- [ ] Create database in Hostinger hPanel
- [ ] Create database user and grant permissions
- [ ] Update `.env` with database credentials
- [ ] Run migrations: `php artisan migrate --force`
- [ ] Run seeders (if needed): `php artisan db:seed`

## Application Setup

- [ ] Install dependencies on server (if not uploaded): `composer install --no-dev`
- [ ] Clear and cache config: `php artisan config:cache`
- [ ] Clear and cache routes: `php artisan route:cache`
- [ ] Clear and cache views: `php artisan view:cache`

## Cron Jobs

- [ ] Set up cron job in Hostinger hPanel:
  ```
  * * * * * cd /path/to/public_html && php artisan schedule:run >> /dev/null 2>&1
  ```

## Testing

- [ ] Visit your domain and verify it loads
- [ ] Test key functionalities
- [ ] Check error logs: `storage/logs/laravel.log`
- [ ] Verify static assets (CSS, JS, images) load correctly
- [ ] Test database connections
- [ ] Test file uploads (if applicable)

## Security

- [ ] Set `APP_DEBUG=false` in `.env`
- [ ] Verify `.env` file is protected (not accessible via web)
- [ ] Enable SSL/HTTPS in Hostinger
- [ ] Update `APP_URL` in `.env` to use HTTPS
- [ ] Review file permissions

## Post-Deployment

- [ ] Monitor error logs for first 24 hours
- [ ] Test all critical features
- [ ] Set up backups (if not automatic)
- [ ] Document any custom configurations

## Troubleshooting

If issues occur:
- [ ] Check `storage/logs/laravel.log`
- [ ] Check Hostinger error logs
- [ ] Verify file permissions
- [ ] Verify `.env` configuration
- [ ] Clear all caches: `php artisan cache:clear && php artisan config:clear && php artisan route:clear && php artisan view:clear`

