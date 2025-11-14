-- KPI: Quantity of non diabetic/diabetic patients and prevalence of diabetes in the dataset
SELECT
	SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END ) AS non_diabetic_patient,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END ) AS diabetic_patient,
	CAST(SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) AS diabetes_rate
FROM patients_diabetes_clean;

--KPI: Glucose values on non diabetic and diabetic patients
SELECT 
	outcome,
	AVG(glucose) AS avg_glucose 
	FROM patients_diabetes_clean
GROUP BY outcome;

-- KPI: Diabetes rate by glucose ranges (clinical classification)
SELECT
    CASE
        WHEN glucose < 100 THEN '<100 (Normal)'
        WHEN glucose BETWEEN 100 AND 139 THEN '100-139 (Prediabetes)'
        WHEN glucose BETWEEN 140 AND 199 THEN '140-199 (High)'
        WHEN glucose >= 200 THEN '>=200 (Very High)'
        ELSE 'Unknown'
    END AS glucose_range,
    
    COUNT(*) AS total_patients,
    SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,

    -- Probability of diabetes in this glucose range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
FROM patients_diabetes_clean
WHERE glucose IS NOT NULL
GROUP BY 
    CASE
        WHEN glucose < 100 THEN '<100 (Normal)'
        WHEN glucose BETWEEN 100 AND 139 THEN '100-139 (Prediabetes)'
        WHEN glucose BETWEEN 140 AND 199 THEN '140-199 (High)'
        WHEN glucose >= 200 THEN '>=200 (Very High)'
        ELSE 'Unknown'
    END
ORDER BY diabetes_rate;

/*
==========================================================
KPI : Conditional Probabilities
==========================================================
-- P(Diabetes | High Glucose)
-- P(High Glucose | Diabetes)
==========================================================
*/

-- P(Diabetes | Glucose >= 140)
SELECT
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 /
    COUNT(*) AS prob_diabetes_given_high_glucose
FROM patients_diabetes_clean
WHERE glucose >= 140;

-- P(Glucose >= 140 | Diabetes)
SELECT
    SUM(CASE WHEN glucose >= 140 THEN 1 ELSE 0 END) * 1.0 /
    COUNT(*) AS prob_high_glucose_given_diabetes
FROM patients_diabetes_clean
WHERE outcome = 1;
