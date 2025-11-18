--KPI: Diabetes rate by skin thickness ranges 
SELECT
	CASE
		WHEN skin_thickness <10 THEN 1
		WHEN skin_thickness BETWEEN 10 AND 20 THEN 2
		WHEN skin_thickness BETWEEN 20 AND 30 THEN 3
		WHEN skin_thickness>= 30 THEN 4
		ELSE 0
	END AS category_index,
	CASE
		WHEN skin_thickness <10 THEN '<10mm (Very low skinfold)'
		WHEN skin_thickness BETWEEN 10 AND 20 THEN '10mm-20mm (low-medium skinfold)'
		WHEN skin_thickness BETWEEN 20 AND 30 THEN '20mm-30mm (medium-high skinfold)'
		WHEN skin_thickness>= 30 THEN '>=30mm (high skinfold)'
		ELSE 'Unknwon'
	END AS skin_thickness_range,
	COUNT(*) AS total_patients,
	SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	-- Probability of diabetes in this blood pressure range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
	FROM patients_diabetes_clean
WHERE skin_thickness IS NOT NULL
GROUP BY
	CASE
		WHEN skin_thickness <10 THEN 1
		WHEN skin_thickness BETWEEN 10 AND 20 THEN 2
		WHEN skin_thickness BETWEEN 20 AND 30 THEN 3
		WHEN skin_thickness>= 30 THEN 4
		ELSE 0
	END,
	CASE
		WHEN skin_thickness <10 THEN '<10mm (Very low skinfold)'
		WHEN skin_thickness BETWEEN 10 AND 20 THEN '10mm-20mm (low-medium skinfold)'
		WHEN skin_thickness BETWEEN 20 AND 30 THEN '20mm-30mm (medium-high skinfold)'
		WHEN skin_thickness>= 30 THEN '>=30mm (high skinfold)'
		ELSE 'Unknwon'
	END
ORDER BY category_index DESC;
/*
1. The distribution of skin thickness values shows that most patients fall 
within the medium-to-high skinfold ranges, while very low skinfold values 
(<10 mm) are extremely rare. Because this group contains only a few 
patients, results from that category should not be interpreted, as the 
sample size is insufficient. This pattern is consistent with the general age 
distribution of the dataset, where younger individuals predominate.

2. Diabetes rates increase progressively as skin thickness increases. While 
the exact percentage change varies, the overall trend shows a clear 
positive association between higher skinfold thickness and higher 
diabetes prevalence. This suggests that greater subcutaneous fat 
may be related to increased diabetes risk within this dataset.
*/

--KPI: Avg skin thickness per diabetic/non diabetic patients
SELECT 
	outcome,
	AVG(skin_thickness) AS avg_skin_thickness,
	COUNT (*) AS total_patients
	FROM patients_diabetes_clean
GROUP BY outcome
/*
The results show that diabetic patients have a higher skin thickness
compared to non-diabetic patients. This is consistent with 
the previous KPI, where higher skin thickness ranges also showed 
higher diabetes rates. Together, both results indicate a positive 
association between high skin thickness and diabetes in this dataset.
*/
