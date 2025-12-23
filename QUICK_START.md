# Quick Start - Deploy to Hostinger

## Fastest Deployment Method

### 1. Prepare Locally (5 minutes)

```bash
# Make script executable (if on Mac/Linux)
chmod +x deploy-to-hostinger.sh

# Run deployment preparation
./deploy-to-hostinger.sh
```

Or manually:
```bash
composer install --optimize-autoloader --no-dev
php artisan key:generate
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### 2. Upload to Hostinger

**Via FTP/SFTP:**
- Connect to your Hostinger hosting
- Upload everything EXCEPT:
  - `.git` folder
  - `.env` file (create on server)
  - `node_modules` (if exists)
  - `.gitignore`, `README.md`, `DEPLOYMENT*.md`

**Via File Manager:**
- Log into Hostinger hPanel
- Go to File Manager → `public_html`
- Upload files

### 3. Configure on Server

1. **Create `.env` file** in root directory with:
   ```env
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://yourdomain.com
   DB_DATABASE=your_db_name
   DB_USERNAME=your_db_user
   DB_PASSWORD=your_db_password
   ```

2. **Set Permissions:**
   - `storage` folder → 775
   - `bootstrap/cache` folder → 775

3. **Install Dependencies** (if vendor folder not uploaded):
   - Via SSH: `composer install --no-dev`
   - Or upload vendor folder from local

4. **Run Migrations:**
   - Via SSH: `php artisan migrate --force`
   - Or import database via phpMyAdmin

5. **Create Storage Link:**
   - Via SSH: `php artisan storage:link`
   - Or create symlink manually: `public/storage` → `../storage/app/public`

6. **Set PHP Version:**
   - hPanel → Advanced → Select PHP Version → Choose PHP 8.2+

7. **Set Cron Job:**
   - hPanel → Advanced → Cron Jobs
   - Add: `* * * * * cd /path/to/public_html && php artisan schedule:run >> /dev/null 2>&1`

### 4. Test

Visit your domain and verify everything works!

## Need More Details?

See `DEPLOYMENT_GUIDE.md` for comprehensive instructions.

## Troubleshooting

**500 Error?**
- Check file permissions
- Check `.env` file exists
- Check error logs: `storage/logs/laravel.log`

**Styles not loading?**
- Verify `APP_URL` in `.env`
- Check `public/storage` symlink exists
- Clear cache: `php artisan cache:clear`

