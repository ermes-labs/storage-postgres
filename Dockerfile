# Use the official postgres image as a parent image
FROM postgres

# Copy the Lua script and the custom entrypoint script into the container
COPY ./scripts/ /docker-entrypoint-initdb.d