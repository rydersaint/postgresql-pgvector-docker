#!/bin/bash
# Start PostgreSQL service
/usr/bin/pg_ctlcluster 16 main start

# Wait for PostgreSQL to start
sleep 10

# Copy pg_hba.conf to the correct location
cp /pg_hba.conf /etc/postgresql/16/main/pg_hba.conf

# Create pgvector extension. Replace 'your_database' with your actual database name.
# su - postgres -c "psql your_database -c 'CREATE EXTENSION pgvector;'"

# Keep the container running
tail -f /dev/null
