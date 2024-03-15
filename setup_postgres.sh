#!/bin/bash
# Start PostgreSQL service
/usr/bin/pg_ctlcluster 16 main start

# Wait for PostgreSQL to start
sleep 10

# Modify listen_addresses to listen on all interfaces
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/16/main/postgresql.conf

# Copy pg_hba.conf to the correct location
cp /pg_hba.conf /etc/postgresql/16/main/pg_hba.conf

# Create the database if it doesn't exist (Replace 'vectortest' with your actual database name)
su - postgres -c "psql -c \"SELECT 1 FROM pg_database WHERE datname = 'vectortest'\" | grep -q 1 || psql -c 'CREATE DATABASE vectortest;'"

# Create pgvector extension
su - postgres -c "psql vectortest -c 'CREATE EXTENSION vector;'"

# Keep the container running
tail -f /dev/null
