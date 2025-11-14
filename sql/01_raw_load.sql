/*
==========================================================
Create Database 
==========================================================
Script Purpose:
	This script creates a new database named 'DiabetesDB'
*/
CREATE DATABASE DiabetesDB;
GO
USE DiabetesDB;
GO

/*
==========================================================
Create Table
==========================================================
Script Purpose:
    This script creates a new table named 'patients_diabetes',
    dropping the table if it already exists. It also loads 
    the data from the CSV file using BULK INSERT and logs 
    the total execution time.
*/

IF OBJECT_ID('patients_diabetes', 'U') IS NOT NULL
	DROP TABLE patients_diabetes;
CREATE TABLE patients_diabetes (
    Pregnancies INT,
    glucose FLOAT,
    blood_pressure FLOAT,
    skin_thickness FLOAT,
    insulin FLOAT,
    bmi FLOAT,
    diabetes_pedigree_function FLOAT,
    age INT,
    outcome BIT
);

DECLARE @start_time DATETIME, @end_time DATETIME
		PRINT '------------------------------------------------------';
		PRINT 'Loading Table';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: patients_diabetes';
		TRUNCATE TABLE patients_diabetes ;
		PRINT '>>Inserting Data Into: patients_diabetes';
		BULK INSERT patients_diabetes
		FROM 'C:\Users\YOGA\Downloads\diabetes.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>>--------------';
