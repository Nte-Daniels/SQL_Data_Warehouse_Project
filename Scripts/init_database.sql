/********************************************************************************************
 Script Name : Create Database and Schemas
 Author      : Nte Daniel Daniel
 Created On  : <2025-12-15>

 Description :
     Creates a new database named 'DataWarehouse' after checking if it already exists.
     If the database exists, it is dropped and recreated. The script also initializes
     three schemas within the database:
         - bronze
         - silver
         - gold

 WARNING :
     Executing this script will DROP the entire 'DataWarehouse' database if it exists.
     All existing data will be permanently deleted.
     Proceed with caution and ensure proper backups are taken before execution.
********************************************************************************************/

USE master;
GO

-- Drop or recreate our 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Creating the 'Datawarehouse' database
CREATE DATABASE DataWarehouse;
GO


USE DataWarehouse;
GO


--Creating our Database Schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

