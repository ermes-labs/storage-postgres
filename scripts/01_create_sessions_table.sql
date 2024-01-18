CREATE TYPE IF NOT EXISTS session_state AS ENUM ('ONLOADING', 'ACTIVE', 'OFFLOADING', 'OFFLOADED');

CREATE TABLE
  IF NOT EXISTS ermes_sessions (
    id uuid PRIMARY KEY,
    client_geo_coordinates POINT NOT NULL DEFAULT NULL,
    static_offloadable_score BIGINT DEFAULT 0,
    created_in TEXT NOT NULL,
    -- Timestamp refers to the UTC timezone.
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    expires_at TIMESTAMP DEFAULT NULL,
    rw_uses UNSIGNED INT DEFAULT 0,
    ro_uses UNSIGNED INT DEFAULT 0,
    state session_state
  );

CREATE INDEX IF NOT EXISTS idx_static_offloadable_score ON sessions USING btree ((rw_uses = 0), static_offloadable_score);

CREATE INDEX IF NOT EXISTS idx_expires_at ON sessions USING btree (expires_at)
WHERE
  rw_uses = 0;

CREATE TABLE
  IF NOT EXISTS ermes_nodes (
    id TEXT PRIMARY KEY,
    host TEXT NOT NULL UNIQUE,
    geo_coordinates POINT NOT NULL,
    parent_id TEXT,
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES ermes_nodes (parent_id)
  );