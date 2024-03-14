# Use Phusion Baseimage as the base image
FROM phusion/baseimage:focal-1.2.0

# Set correct environment variables
ENV HOME /root

# Use baseimage's init system
CMD ["/sbin/my_init"]

# Install PostgreSQL and dependencies
RUN apt-get update && \
    apt-get install -y gnupg2 lsb-release curl && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-16* postgresql-contrib-16* postgresql-server-dev-16* build-essential git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clone, compile, and install pgvector
RUN set -e && \
    git clone https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install && \
    # Echo contents to check the installation paths
    echo "Listing /usr/lib/postgresql/16/lib:" && ls -la /usr/lib/postgresql/16/lib/ && \
    echo "Listing /usr/share/postgresql/16/extension:" && ls -la /usr/share/postgresql/16/extension/

# Copy the custom pg_hba.conf file into the Docker image
COPY pg_hba.conf /pg_hba.conf

# Add a script to setup PostgreSQL service, including pgvector setup
RUN mkdir /etc/service/postgres
ADD setup_postgres.sh /etc/service/postgres/run
RUN chmod +x /etc/service/postgres/run
