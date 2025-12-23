# Hostinger Shared Hosting Deployment Guide

This guide will help you deploy your Laravel application on Hostinger shared hosting.

## Prerequisites

- Hostinger shared hosting account
- FTP/SFTP access or File Manager access
- SSH access (if available) - recommended
- PHP 8.2 or higher
- Composer installed locally

## Step 1: Prepare Your Application Locally

1. **Install dependencies** (if not already done):
   ```bash
   composer install --optimize-autoloader --no-dev
   ```

2. **Generate application key** (if not set):
   ```bash
   php artisan key:generate
   ```

3. **Optimize for production**:
   ```bash
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```

## Step 2: Upload Files to Hostinger

### Option A: Using FTP/SFTP (Recommended)

1. Connect to your Hostinger hosting via FTP/SFTP
2. Navigate to your domain's root directory (usually `public_html` or `htdocs`)
3. Upload ALL files and folders EXCEPT:
   - `.git` folder (if exists)
   - `.env` file (you'll create this on server)
   - `node_modules` (if exists)
   - `tests` folder (optional)
   - `.gitignore`
   - `README.md`
   - `DEPLOYMENT_GUIDE.md`

### Option B: Using File Manager

1. Log into Hostinger control panel (hPanel)
2. Go to File Manager
3. Navigate to `public_html` folder
4. Upload files using the upload feature

## Step 3: Configure Directory Structure

For Hostinger shared hosting, you have two options:

### Option 1: Standard Laravel Structure (Recommended if you have SSH access)

Keep the standard Laravel structure:
```
public_html/
├── app/
├── bootstrap/
├── config/
├── database/
├── public/
│   ├── index.php
│   ├── .htaccess
│   └── assets/
├── resources/
├── routes/
├── storage/
├── vendor/
├── .env
├── .htaccess
└── composer.json
```

Then create a `.htaccess` in `public_html` root that redirects to `public` folder (see Step 4).

### Option 2: Move Public Contents (If no SSH access)

1. Move all contents from `public/` folder to `public_html/` root
2. Move all other Laravel folders one level up (outside public_html)
3. Update `public_html/index.php` paths (see Step 5)

**Structure:**
```
/
├── app/
├── bootstrap/
├── config/
├── database/
├── public_html/  (contains public folder contents)
│   ├── index.php
│   ├── .htaccess
│   └── assets/
├── resources/
├── routes/
├── storage/
├── vendor/
├── .env
└── composer.json
```

## Step 4: Configure .htaccess Files

### If using Option 1 (Standard Structure):

Create/update `.htaccess` in `public_html` root:
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^(.*)$ public/$1 [L]
</IfModule>
```

### If using Option 2 (Moved Public Contents):

The `.htaccess` in `public_html` is already configured correctly.

## Step 5: Update index.php (Only if using Option 2)

If you moved public contents, update `public_html/index.php`:

Change:
```php
require __DIR__.'/../vendor/autoload.php';
$app = require_once __DIR__.'/../bootstrap/app.php';
```

To:
```php
require __DIR__.'/../vendor/autoload.php';
$app = require_once __DIR__.'/../bootstrap/app.php';
```

(Paths remain the same if structure is correct)

## Step 6: Set Up Environment File

1. Create `.env` file in the root directory (same level as `composer.json`)
2. Copy from `.env.example` if available, or create new one
3. Configure the following essential settings:

```env
APP_NAME="BingoBites"
APP_ENV=production
APP_KEY=base64:YOUR_GENERATED_KEY_HERE
APP_DEBUG=false
APP_URL=https://yourdomain.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password

# Storage and cache
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync

# Mail configuration (use Hostinger SMTP)
MAIL_MAILER=smtp
MAIL_HOST=smtp.hostinger.com
MAIL_PORT=465
MAIL_USERNAME=your_email@yourdomain.com
MAIL_PASSWORD=your_email_password
MAIL_ENCRYPTION=ssl
MAIL_FROM_ADDRESS=your_email@yourdomain.com
MAIL_FROM_NAME="${APP_NAME}"
```

**Important:** Get database credentials from Hostinger hPanel → Databases section.

## Step 7: Set File Permissions

Set proper permissions (via File Manager or SSH):

```bash
# Storage and cache directories
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# If using SSH, run:
php artisan storage:link
```

Via File Manager:
- Right-click `storage` folder → Permissions → Set to 775
- Right-click `bootstrap/cache` folder → Permissions → Set to 775

## Step 8: Install Dependencies on Server

### If you have SSH access:

```bash
cd /home/username/public_html  # or your actual path
composer install --optimize-autoloader --no-dev
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### If you DON'T have SSH access:

1. Upload the `vendor` folder from your local machine (after running `composer install --no-dev`)
2. Or use Hostinger's PHP Composer tool in hPanel if available

## Step 9: Run Database Migrations

### If you have SSH access:

```bash
php artisan migrate --force
php artisan db:seed  # if you have seeders
```

### If you DON'T have SSH access:

1. Use Hostinger's PHP CLI tool in hPanel
2. Or import your database manually via phpMyAdmin

## Step 10: Create Storage Link

### If you have SSH access:

```bash
php artisan storage:link
```

### If you DON'T have SSH access:

Create a symbolic link manually or use Hostinger's file manager to create a symlink from:
- `public/storage` → `../storage/app/public`

## Step 11: Configure PHP Settings

In Hostinger hPanel:
1. Go to **Advanced** → **Select PHP Version**
2. Select PHP 8.2 or higher
3. Enable required extensions:
   - `curl`
   - `gd` or `imagick`
   - `mbstring`
   - `openssl`
   - `pdo_mysql`
   - `zip`
   - `fileinfo`

## Step 12: Set Up Cron Jobs

In Hostinger hPanel → **Advanced** → **Cron Jobs**:

Add this cron job to run every minute:
```bash
* * * * * cd /home/username/public_html && php artisan schedule:run >> /dev/null 2>&1
```

Replace `/home/username/public_html` with your actual path.

## Step 13: Test Your Application

1. Visit your domain: `https://yourdomain.com`
2. Check if the application loads correctly
3. Test key functionalities
4. Check error logs in `storage/logs/laravel.log` if issues occur

## Troubleshooting

### Issue: 500 Internal Server Error
- Check file permissions (storage, bootstrap/cache should be 775)
- Check `.env` file exists and is configured correctly
- Check error logs in `storage/logs/laravel.log`
- Verify PHP version is 8.2+

### Issue: Styles/Images Not Loading
- Check `APP_URL` in `.env` matches your domain
- Verify `public/storage` symlink exists
- Clear cache: `php artisan cache:clear && php artisan config:clear`

### Issue: Database Connection Error
- Verify database credentials in `.env`
- Check database exists in Hostinger
- Verify database user has proper permissions

### Issue: Composer Dependencies Missing
- Upload `vendor` folder or run `composer install` via SSH
- Check `composer.json` is uploaded

## Security Checklist

- [ ] Set `APP_DEBUG=false` in production
- [ ] Use strong `APP_KEY`
- [ ] Protect `.env` file (already done via .htaccess)
- [ ] Use HTTPS (enable SSL in Hostinger)
- [ ] Set proper file permissions
- [ ] Keep Laravel and packages updated
- [ ] Use strong database passwords

## Additional Notes

- Hostinger shared hosting may have execution time limits
- Some Laravel features may require VPS/dedicated server
- Check Hostinger's resource limits (memory, execution time)
- Consider upgrading to VPS if you need more control

## Support

If you encounter issues:
1. Check Laravel logs: `storage/logs/laravel.log`
2. Check Hostinger error logs in hPanel
3. Enable debug temporarily to see errors (remember to disable after)
4. Contact Hostinger support for hosting-specific issues

