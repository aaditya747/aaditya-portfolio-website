# Aaditya Mahajan — Anime.js Portfolio + Detailed Activity Log

## What is included
- Cinematic multi-section portfolio with separate page-like navigation.
- Anime.js 3.2.2 animation layer.
- Real project file explorer and assets.
- PHP + MySQL consent-based activity tracking.
- Private password-protected `admin.php` dashboard.
- MySQL schema: `database/schema.sql`.

## What activity is recorded?
Only after a visitor explicitly clicks **Allow analytics**:
- Session start.
- Page views and page exits.
- Internal navigation.
- Project folder openings.
- Project subfolder openings.
- File preview openings.
- Download-link clicks.
- External-link clicks.
- File-search usage (the search phrase is NOT recorded).
- Scroll milestones (25%, 50%, 75%, 90%).
- Time spent on a page until route change.
- Random pseudonymous browser token and session token.
- Page title/path, clicked label/URL, element ID/class and referrer.
- Screen dimensions and browser language.
- Coarse IP network prefix, browser, operating system and device category.

It does NOT collect email addresses, typed text, passwords, form contents, keystrokes, exact device names, mouse movements or a complete browsing history outside this portfolio.

A browser token is not a verified real-world identity. The same person can appear as multiple visitors across browsers/devices, and a shared browser can represent multiple people. A download event means a download link was clicked, not that the file was successfully saved.

## Database columns
`portfolio_events` stores one row per event:
- `visitor_id`, `session_id`
- `event_type`, `target_type`, `target_label`, `target_url`
- `page_path`, `page_title`
- `element_id`, `element_class`, `referrer`
- `screen_width`, `screen_height`, `language_code`
- `duration_ms`, `scroll_percent`
- `ip_prefix`, `user_agent`, `browser`, `operating_system`, `device_type`
- `consent_given`, `created_at`

## 1. Hosting requirement
Choose hosting that supports **PHP 8+ and MySQL**. Static-only hosting such as GitHub Pages cannot run the PHP API.

## 2. Create the MySQL database
In your hosting control panel:
1. Open **MySQL Databases**.
2. Create a database (example: `aaditya_portfolio`).
3. Create a database user and strong password.
4. Assign the user to the database with required privileges.
5. Open **phpMyAdmin**.
6. Select the new database → **Import**.
7. Upload `database/schema.sql` from this package and click **Import/Go**.
8. Confirm the `portfolio_events` table appears.

## 3. Configure environment variables
Set these securely in the hosting control panel / PHP-FPM environment:
- `DB_HOST` — exact database host supplied by hosting provider (often `localhost`).
- `DB_NAME` — database name.
- `DB_USER` — database username.
- `DB_PASS` — database password.
- `ANALYTICS_ADMIN_USER` — private dashboard username.
- `ANALYTICS_ADMIN_PASS` — long, unique dashboard password.

Never place database credentials in HTML/JavaScript or commit them to GitHub. If the host does not support environment variables, ask its support for the secure PHP configuration method; do not expose secrets in a web-accessible file.

## 4. Upload the website
Upload the contents of `Aaditya_Neon_Portfolio` into the hosting web root (`public_html` or equivalent), preserving:
```text
public_html/
  index.html
  admin.php
  api/
    config.php
    event.php
  database/
    schema.sql
  projects/
  .htaccess
```
Enable HTTPS/SSL before publishing.

## 5. Open your private activity log
Visit `https://YOUR-DOMAIN/admin.php` and sign in with the configured admin username/password. The dashboard shows aggregate counts, most interacted items and the latest 500 event records.

Do not link `admin.php` from the public portfolio or share the credentials.

## 6. Test the setup
1. Open the public site in a fresh browser.
2. Click **Allow analytics**.
3. Open About, Projects and a project folder.
4. Preview a file and click a download link.
5. Visit `/admin.php` in another tab and check that events appear.
6. Use a separate browser to click **Decline** and verify that no new events are sent from it.

## Privacy and security
- Explain tracking clearly and honour Decline.
- Retain only data you need; 90 days is a suggested starting retention period.
- Provide a privacy contact and deletion process before going live.
- Do not attempt to identify individuals from IP prefixes or browser data.
- Keep `admin.php` private, use HTTPS and a strong password.
- Do not expose raw activity records through a public API.
- The `.htaccess` blocks direct access to `config.php` and `schema.sql` on Apache hosts; verify equivalent protection if using another server.

## Local preview
For visual preview, open the folder in VS Code and use Live Server. PHP tracking will not work with Live Server alone. To test the full database flow locally, use XAMPP (Apache + PHP + MySQL), import the schema and configure the PHP environment variables.
