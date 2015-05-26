README
======

Development
-----------

### Install Postgresql

    $ sudo aptitude install postgresql-9.1 postgresql-server-dev-9.1

Package `postgresql-server-dev-9.1` required to build gem `pg`.

### Configure Postgresql

    $ sudo -u postgres psql

This will run PostgreSQL shell.

    CREATE ROLE sdmv WITH PASSWORD 'sdmv';
    ALTER ROLE sdmv WITH LOGIN;
    ALTER ROLE sdmv WITH CREATEDB;
    \q

### Setup database

    $ rake db:setup
