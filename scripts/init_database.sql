/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'datawarehous' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'datawarehous' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


-- Drop and recreate the 'datawarehouse' database
DROP DATABASE IF EXISTS "datawarehouse" WITH (FORCE)
CREATE DATABASE "datawarehous"
  

-- Create Schemas
CREATE SCHEMA IF NOT EXISTS bronze
CREATE SCHEMA IF NOT EXISTS sylver
CREATE SCHEMA IF NOT EXISTS gold
