--KPI: Diabetes rate by blood pressure ranges 
SELECT
	CASE
		WHEN blood_pressure <80 THEN 1
		WHEN blood_pressure BETWEEN 80 AND 89 THEN 2
		WHEN blood_pressure BETWEEN 90 AND 99 THEN 3
		WHEN blood_pressure>= 100 THEN 4
		ELSE 0
	END AS category_index,
	CASE
		WHEN blood_pressure <80 THEN '<80 (Normal)'
		WHEN blood_pressure BETWEEN 80 AND 89 THEN '80-89 (Prehypertension)'
		WHEN blood_pressure BETWEEN 90 AND 99 THEN '90-99 (hypertension stage 1)'
		WHEN blood_pressure>= 100 THEN '>=100 (hypertension stage 2)'
		ELSE 'Unknwon'
	END AS blood_pressure_range,
	COUNT(*) AS total_patients,
	SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	-- Probability of diabetes in this blood pressure range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
	FROM patients_diabetes_clean
WHERE blood_pressure IS NOT NULL
GROUP BY
	CASE
		WHEN blood_pressure <80 THEN 1
		WHEN blood_pressure BETWEEN 80 AND 89 THEN 2
		WHEN blood_pressure BETWEEN 90 AND 99 THEN 3
		WHEN blood_pressure>= 100 THEN 4
		ELSE 0
	END,
	CASE
		WHEN blood_pressure <80 THEN '<80 (Normal)'
		WHEN blood_pressure BETWEEN 80 AND 89 THEN '80-89 (Prehypertension)'
		WHEN blood_pressure BETWEEN 90 AND 99 THEN '90-99 (hypertension stage 1)'
		WHEN blood_pressure>= 100 THEN '>=100 (hypertension stage 2)'
		ELSE 'Unknwon'
	END
ORDER BY category_index DESC;
/*
1. Most patients in the dataset have normal blood pressure, which is 
expected considering the age distribution of the sample. This means that 
the higher-risk blood pressure groups are underrepresented.

2. Diabetes rates increase progressively with blood pressure levels. 
Patients in Stage 2 Hypertension show the highest diabetes prevalence, 
while those in the normal range show the lowest. This indicates a 
positive association between elevated blood pressure and diabetes risk, 
although not necessarily a linear relationship.

3. The number of patients with Stage 2 Hypertension is very small, so 
interpretations involving this category should be taken cautiously. The 
dataset does not provide enough evidence to establish strong conclusions 
about the highest blood pressure group.

*/

--KPI: Avg blood pressure per diabetic/non diabetic patients
SELECT 
	outcome,
	AVG(blood_pressure) AS avg_blood_pressure,
	COUNT (*) AS total_patients
	FROM patients_diabetes_clean
GROUP BY outcome
/*
The results show that diabetic patients have a higher average blood 
pressure compared to non-diabetic patients. This is consistent with 
the previous KPI, where higher blood pressure ranges also showed 
higher diabetes rates. Together, both results indicate a positive 
association between elevated blood pressure and diabetes in this dataset.
*/
