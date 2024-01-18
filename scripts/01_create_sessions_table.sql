
CREATE TYPE IF NOT EXISTS session_state AS ENUM ('value1', 'value2', 'value3', 'value4');
CREATE TABLE IF NOT EXISTS sessions (
  id SERIAL PRIMARY KEY,
  client_geo_coordinates POINT,
  static_offloadable_score BIGINT,
  created_in TEXT,
  -- Timestamp refers to the UTC timezone.
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  expires_at TIMESTAMP,
  rw_uses UNSIGNED INT,
  ro_uses UNSIGNED INT,
  state session_state
);

CREATE INDEX IF NOT EXISTS idx_static_offloadable_score ON sessions (static_offloadable_score);


