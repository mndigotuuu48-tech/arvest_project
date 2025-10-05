# Arvest Project Deployment Guide

## Deploying to Coolify with Nixpacks

This guide will help you deploy your PHP project to Coolify on an Ubuntu server using Nixpacks.

### Prerequisites

1. Coolify instance running on Ubuntu server
2. Git repository with your project code
3. Domain name (optional but recommended)

### Files Created for Deployment

- `nixpacks.toml` - Nixpacks configuration for PHP 8.2 with Apache
- `.htaccess` - Apache configuration for URL rewriting and security
- `composer.json` - PHP dependencies management
- `Dockerfile` - Alternative Docker deployment option

### Deployment Steps

1. **Push your code to Git repository**
   ```bash
   git add .
   git commit -m "Add deployment configuration"
   git push origin main
   ```

2. **In Coolify Dashboard:**
   - Create a new project
   - Connect your Git repository
   - Select "Nixpacks" as the buildpack
   - The `nixpacks.toml` file will be automatically detected

3. **Environment Variables (if needed):**
   - Add any required environment variables in Coolify
   - For example: `APACHE_DOCUMENT_ROOT=/app`

4. **Deploy:**
   - Click "Deploy" in Coolify
   - Monitor the build logs
   - Your application will be available at the provided URL

### Configuration Details

#### Nixpacks Configuration
- Uses PHP 8.2
- Includes Apache HTTP server
- Enables PHP module for Apache
- Sets up proper document root

#### Apache Configuration
- Enables mod_rewrite for clean URLs
- Sets up security headers
- Configures caching for static assets
- Hides sensitive files (.txt, .log)

#### Security Features
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection enabled
- Sensitive files are hidden from direct access

### Troubleshooting

1. **Build fails:**
   - Check the build logs in Coolify
   - Ensure all files are committed to Git
   - Verify PHP syntax is correct

2. **Application not loading:**
   - Check if Apache is running
   - Verify file permissions
   - Check Apache error logs

3. **Static assets not loading:**
   - Ensure .htaccess is in the root directory
   - Check if mod_rewrite is enabled
   - Verify file paths in HTML

### Alternative: Docker Deployment

If you prefer Docker over Nixpacks:
1. Use the provided `Dockerfile`
2. Select "Dockerfile" as the build method in Coolify
3. The Dockerfile will build a PHP 8.2 + Apache container

### Monitoring

- Check Coolify logs for any issues
- Monitor application performance
- Set up health checks if needed

### Next Steps

1. Configure your domain name in Coolify
2. Set up SSL certificate
3. Configure any required environment variables
4. Test all functionality after deployment

