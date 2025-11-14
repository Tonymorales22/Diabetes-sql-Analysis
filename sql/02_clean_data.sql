SELECT COUNT(*) AS total_rows FROM patients_diabetes;
--Data Quality Check:
--Count clinicaly impossible values coded as zero in key health variables
--These zeros represent missing values and will be converted to NULL during cleaning.
SELECT 
	SUM(CASE WHEN glucose = 0 THEN 1 ELSE 0 END) AS zero_glucose,
	SUM(CASE WHEN blood_pressure = 0 THEN 1 ELSE 0 END) AS zero_blood_pressure,
	SUM(CASE WHEN skin_thickness = 0 THEN 1 ELSE 0 END) AS zero_skin_thickness,
	SUM(CASE WHEN insulin = 0 THEN 1 ELSE 0 END) AS zero_insulin,
	SUM(CASE WHEN bmi = 0 THEN 1 ELSE 0 END) AS zero_bmi
FROM patients_diabetes;

-- ==============================================================
-- DATA SEPARATION (RAW → CLEAN LAYER)
-- Purpose:
--   Create a CLEAN version of the dataset where clinically
--   impossible values (zeros) are converted to NULL.
--   The original RAW table remains intact for reproducibility.
-- ==============================================================

IF OBJECT_ID('patients_diabetes_clean', 'U') IS NOT NULL
    DROP TABLE patients_diabetes_clean;

SELECT
    pregnancies,
    -- Replace clinically impossible values with NULL
    NULLIF(glucose, 0) AS glucose,
    NULLIF(blood_pressure, 0) AS blood_pressure,
    NULLIF(skin_thickness, 0) AS skin_thickness,
    NULLIF(insulin, 0) AS insulin,
    NULLIF(bmi, 0) AS bmi,
    diabetes_pedigree_function,
    age,
    outcome
INTO patients_diabetes_clean
FROM patients_diabetes;


-- Quick inspection of the clean dataset
SELECT TOP 10 * 
FROM patients_diabetes_clean;

-- Verify total number of rows
SELECT COUNT(*) AS total_rows 
FROM patients_diabetes_clean;


-- ==============================================================
-- DATA QUALITY CHECK ON CLEAN LAYER
-- Purpose:
--   Ensure that zeros have been successfully normalized to NULL
--   and that no clinically impossible values remain.
-- ==============================================================

SELECT 
    SUM(CASE WHEN glucose IS NULL THEN 1 ELSE 0 END) AS null_glucose,
    SUM(CASE WHEN blood_pressure IS NULL THEN 1 ELSE 0 END) AS null_blood_pressure,
    SUM(CASE WHEN skin_thickness IS NULL THEN 1 ELSE 0 END) AS null_skin_thickness,
    SUM(CASE WHEN insulin IS NULL THEN 1 ELSE 0 END) AS null_insulin,
    SUM(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END) AS null_bmi
FROM patients_diabetes_clean;
