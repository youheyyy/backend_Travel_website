-- Drop and recreate database with UTF-8 encoding
DROP DATABASE IF EXISTS travel_website;

CREATE DATABASE travel_website
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TEMPLATE = template0;
