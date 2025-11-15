/*==========================================================
03 – Glucose KPI Analysis
Dataset: Pima Indians Diabetes
Purpose: Analyze glucose-related risk factors and their
         association with diabetes incidence.
==========================================================*/


/*==========================================================
KPI 1 – Diabetes vs Non-Diabetes Count
==========================================================*/
SELECT
	SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END ) AS non_diabetic_patient,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END ) AS diabetic_patient,
	CAST(SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) AS diabetes_rate
FROM patients_diabetes_clean;

/*
INSIGHT:
There are nearly twice as many non-diabetic patients as diabetic ones.
The overall diabetes prevalence in the dataset is approximately 34.9%.

Because the diabetic group is significantly smaller, statistical estimates
involving diabetic patients may be slightly less stable compared to those 
based on non-diabetic patients.
*/

/*==========================================================
KPI 2 – Average Glucose by Outcome
==========================================================*/
SELECT 
	outcome,
	AVG(glucose) AS avg_glucose 
	FROM patients_diabetes_clean
GROUP BY outcome;

/*
INSIGHT:
Diabetic patients show substantially higher average glucose levels than 
non-diabetic patients (an approximate difference of ~30 mg/dL). 

This confirms the clinical relevance of glucose as a strong indicator of
diabetes risk.
*/


/*==========================================================
KPI 3 – Diabetes Rate by Glucose Ranges (Clinical Categories)
==========================================================*/
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
INSIGHT:
Patients with glucose ≥140 mg/dL exhibit a diabetes rate close to 70%, 
more than double the rate observed in the 100–139 mg/dL range (~31%). 

Meanwhile, patients in the normal glucose range (<100 mg/dL) show a very low 
diabetes rate (<10%). 

This gradient clearly demonstrates the strong association between elevated 
glucose levels and diabetes risk.
*/


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
/*
INSIGHT:
The probability of having diabetes given high glucose levels (glucose ≥140)
is very high, close to 70%. This means elevated glucose is a strong predictor 
of diabetes.

However, the probability of having high glucose among diabetic patients is 
significantly lower, indicating that high glucose is not a strict requirement 
for diabetes diagnosis. This asymmetry highlights why conditional analysis is 
essential when studying clinical risk factors.
*/
