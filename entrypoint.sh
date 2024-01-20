#!/bin/bash
set -e

# Env variables:
# - ERMES_NODE_ID: the node ID of the ERMES node to be created

# Generate a new SQL file from the template, replacing the placeholder
sed "s/ERMES_NODE_ID/${ERMES_NODE_ID}/g" /docker-entrypoint-initdb.d/00_setup.sql.template >/docker-entrypoint-initdb.d/00_setup.sql

# Call the original entrypoint script
exec docker-entrypoint.sh postgres
