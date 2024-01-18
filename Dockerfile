# Use the official postgres image as a parent image
FROM postgres:latest

# Copy the sql scripts
COPY ./scripts/ /docker-entrypoint-initdb.d
# Copy the custom entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the custom script as the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]