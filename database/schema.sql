-- Select your database in phpMyAdmin, then import this file.
-- Analytics events are sent only after a visitor explicitly accepts the consent notice.
-- visitor_id is a random pseudonymous browser token; session_id is a temporary session token.
-- IP is stored as a coarse prefix, not a full IP address.

CREATE TABLE portfolio_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  visitor_id VARCHAR(80) NOT NULL,
  session_id VARCHAR(80) NOT NULL,
  event_type VARCHAR(40) NOT NULL,
  target_type VARCHAR(40) NOT NULL DEFAULT '',
  target_label VARCHAR(180) NOT NULL DEFAULT '',
  target_url VARCHAR(500) NOT NULL DEFAULT '',
  page_path VARCHAR(180) NOT NULL DEFAULT '',
  page_title VARCHAR(200) NOT NULL DEFAULT '',
  element_id VARCHAR(100) NOT NULL DEFAULT '',
  element_class VARCHAR(180) NOT NULL DEFAULT '',
  referrer VARCHAR(500) NOT NULL DEFAULT '',
  screen_width SMALLINT UNSIGNED NULL,
  screen_height SMALLINT UNSIGNED NULL,
  language_code VARCHAR(20) NOT NULL DEFAULT '',
  duration_ms INT UNSIGNED NOT NULL DEFAULT 0,
  scroll_percent TINYINT UNSIGNED NOT NULL DEFAULT 0,
  ip_prefix VARCHAR(64) NOT NULL,
  user_agent VARCHAR(500) NOT NULL,
  browser VARCHAR(40) NOT NULL,
  operating_system VARCHAR(40) NOT NULL,
  device_type VARCHAR(20) NOT NULL,
  consent_given TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_events_time (created_at),
  INDEX idx_events_visitor (visitor_id),
  INDEX idx_events_session (session_id),
  INDEX idx_events_type (event_type),
  INDEX idx_events_page (page_path)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Optional 90-day retention cleanup:
-- DELETE FROM portfolio_events WHERE created_at < NOW() - INTERVAL 90 DAY;
