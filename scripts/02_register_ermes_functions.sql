-- Function that create a session and acquire it in read-write mode.
CREATE OR REPLACE FUNCTION create_and_rw_acquire(client_geo_coordinates POINT, expires_at NUMERIC)
RETURNS TEXT AS $$
DECLARE
  session_geo_coordinates POINT;
  sessionId uuid;
  created_in TEXT;
BEGIN
  -- The key is taken from a Postgres config variable.
  created_in := (SELECT setting FROM pg_settings WHERE name = 'ermes_node_id');
  -- if client_geo_coordinates is null, retrieve the one from the node.
  IF client_geo_coordinates IS NULL THEN
    session_geo_coordinates := (SELECT geo_coordinates FROM ermes_nodes where nodeId = created_in);
  ELSE
    session_geo_coordinates := client_geo_coordinates;
  END IF;

  -- Continue until a new session is created.
  LOOP
    -- Generate a new UUID
    sessionId := gen_random_uuid();

    -- Attempt to insert a row with the generated UUID
    BEGIN
      INSERT INTO ermes_sessions (id, client_geo_coordinates, static_offloadable_score, created_in, created_at, updated_at, expires_at, rw_uses, ro_uses, state)
      VALUES (sessionId, session_geo_coordinates, 0, created_in, NOW(), NOW(), expires_at, 1, 0, 'ACTIVE');
      -- If the insertion is successful, exit the loop
      EXIT;
    EXCEPTION
      -- If the UUID is already in use, continue the loop to generate a new one
      WHEN unique_violation THEN
        CONTINUE;
    END;
  END LOOP;

  -- Return the generated session ID
  RETURN sessionId;
END;
$$ LANGUAGE plpgsql;



-- Function that create a session and acquire it in read-only mode.
CREATE OR REPLACE FUNCTION create_and_ro_acquire(client_geo_coordinates POINT, expires_at NUMERIC)
RETURNS TEXT AS $$
DECLARE
  session_geo_coordinates POINT;
  sessionId uuid;
  created_in TEXT;
BEGIN
  -- The key is taken from a Postgres config variable.
  created_in := (SELECT setting FROM pg_settings WHERE name = 'ermes_node_id');
  -- if client_geo_coordinates is null, retrieve the one from the node.
  IF client_geo_coordinates IS NULL THEN
    session_geo_coordinates := (SELECT geo_coordinates FROM ermes_nodes where nodeId = created_in);
  ELSE
    session_geo_coordinates := client_geo_coordinates;
  END IF;

  -- Continue until a new session is created.
  LOOP
    -- Generate a new UUID
    sessionId := gen_random_uuid();

    -- Attempt to insert a row with the generated UUID
    BEGIN
      INSERT INTO ermes_sessions (id, client_geo_coordinates, static_offloadable_score, created_in, created_at, updated_at, expires_at, rw_uses, ro_uses, state)
      VALUES (sessionId, session_geo_coordinates, 0, created_in, NOW(), NOW(), expires_at, 0, 1, 'ACTIVE');
      -- If the insertion is successful, exit the loop
      EXIT;
    EXCEPTION
      -- If the UUID is already in use, continue the loop to generate a new one
      WHEN unique_violation THEN
        CONTINUE;
    END;
  END LOOP;

  -- Return the generated session ID
  RETURN sessionId;
END;
$$ LANGUAGE plpgsql;


-- Function that create a session and set it for onload.
CREATE OR REPLACE FUNCTION onload_start(sessionId TEXT, client_geo_coordinates POINT, created_in TEXT, created_at NUMERIC, updated_at NUMERIC, expires_at NUMERIC)
RETURNS TEXT AS $$
DECLARE
  session_geo_coordinates POINT;
  sessionId uuid;
  created_in TEXT;
BEGIN
  -- The key is taken from a Postgres config variable.
  created_in := (SELECT setting FROM pg_settings WHERE name = 'ermes_node_id');
  -- if client_geo_coordinates is null, retrieve the one from the node.
  IF client_geo_coordinates IS NULL THEN
    session_geo_coordinates := (SELECT geo_coordinates FROM ermes_nodes where nodeId = created_in);
  ELSE
    session_geo_coordinates := client_geo_coordinates;
  END IF;

  -- Continue until a new session is created.
  LOOP
    -- Generate a new UUID
    sessionId := gen_random_uuid();

    -- Attempt to insert a row with the generated UUID
    BEGIN
      INSERT INTO ermes_sessions (id, client_geo_coordinates, static_offloadable_score, created_in, created_at, updated_at, expires_at, rw_uses, ro_uses, state)
      VALUES (sessionId, client_geo_coordinates, 0, created_in, created_at, updated_at, expires_at, 0, 0, 'ONLOADING');
      -- If the insertion is successful, exit the loop
      EXIT;
    EXCEPTION
      -- If the UUID is already in use, continue the loop to generate a new one
      WHEN unique_violation THEN
        CONTINUE;
    END;
  END LOOP;

  -- Return the generated session ID
  RETURN sessionId;
END;

