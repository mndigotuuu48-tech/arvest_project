## PHP + Apache on Coolify (Generic Template)

These files help deploy a standard PHP site behind Coolify/Traefik with real client IPs, environment variables, and production defaults.

### Files
- `Dockerfile`: Production PHP 8.2 + Apache, common extensions, RemoteIP enabled.
- `docker/vhost.conf`: Apache virtual host with `mod_rewrite`, logs to stdout/stderr, security headers.
- `docker/php.ini`: Production-leaning PHP settings, logs to stderr.
- `.dockerignore`: Excludes dev artifacts, secrets, and heavy folders from build context.
- `docker-compose.yml` (optional): Local testing, plus DB/cron examples.

### PHP Extensions included
- gd, intl, mbstring, zip, mysqli, pdo_mysql
- Adjust `Dockerfile` if you need others.

### Environment variables
Set secrets in Coolify (Application → Environment Variables):
- `ANTIBOT_API_KEY`: e.g., your external API key.
- `ANTIBOT_ENDPOINT`: e.g., `https://api.example.com`.
- Database variables (if needed): `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`.

Access in PHP:
```php
$apiKey = getenv('ANTIBOT_API_KEY') ?: '';
$endpoint = getenv('ANTIBOT_ENDPOINT') ?: 'https://api.example.com';
```

Never commit real secrets. For local dev, you can use a `.env` file with `docker compose` but keep it out of version control and out of images.

### Real client IPs behind Coolify/Traefik
- The Dockerfile enables `mod_remoteip` and sets `RemoteIPHeader X-Forwarded-For`.
- Apache replaces `REMOTE_ADDR` with the client IP from the proxy.
- Do not manually trust `HTTP_X_FORWARDED_FOR`; let Apache handle it.

### Coolify deployment checklist
1. DNS: Point your domain/subdomain to your server’s public IP (A/AAAA records).
2. Create App: In Coolify, create a new Application (Dockerfile type).
3. Repo/Code: Link your Git repo (or upload) with `Dockerfile` in project root.
4. Env Vars: Add required environment variables (e.g., `ANTIBOT_API_KEY`, DB_*).
5. Port: Internal port is 80 by default for Apache. No host ports needed.
6. Domain/SSL: Assign your domain in Coolify. Enable Let’s Encrypt and deploy.
7. Deploy: Run the deployment. Check container logs for readiness.
8. Verify: Confirm HTTPS works and logs show real client IPs.
9. Optional DB/cron: Add separate services or containers as needed.

### Local testing
- Build and run: `docker compose up --build`
- Visit: `http://localhost:8080`

### Notes
- If your app needs writable directories (uploads/cache), bind-mount or create a Docker volume and chown to `www-data`.
- If you require more Apache modules, enable in the `Dockerfile` via `a2enmod`.
- For Nginx + PHP-FPM, create an alternate `Dockerfile` and a site config accordingly.
