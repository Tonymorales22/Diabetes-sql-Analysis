--KPI: total patients and diabetes rate per insulin ranges
SELECT
	CASE 
		WHEN insulin < 75 THEN 1
		WHEN insulin BETWEEN 75 AND 150 THEN 2
		WHEN insulin BETWEEN 150 AND 300 THEN 3
		WHEN insulin>= 300 THEN 4
		ELSE 0
	END AS category_index,
	CASE 
		WHEN insulin < 75 THEN '<75 (Normal)'
		WHEN insulin BETWEEN 75 AND 150 THEN '75-150 (mild hyperinsulinemia)'
		WHEN insulin BETWEEN 150 AND 300 THEN '150-300 (moderate hyperinsulinemia)'
		WHEN insulin>= 300 THEN '>=300 (severe hyperinsulinemia)'
		ELSE 'Unknown'
	END AS insulin_ranges,
	COUNT(*) AS total_patients,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
	SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
	SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
		AS diabetes_rate
	FROM patients_diabetes_clean
WHERE insulin IS NOT NULL
GROUP BY 
	CASE 
		WHEN insulin < 75 THEN 1
		WHEN insulin BETWEEN 75 AND 150 THEN 2
		WHEN insulin BETWEEN 150 AND 300 THEN 3
		WHEN insulin>= 300 THEN 4
		ELSE 0
	END,

	CASE 
		WHEN insulin < 75 THEN '<75 (Normal)'
		WHEN insulin BETWEEN 75 AND 150 THEN '75-150 (mild hyperinsulinemia)'
		WHEN insulin BETWEEN 150 AND 300 THEN '150-300 (moderate hyperinsulinemia)'
		WHEN insulin>= 300 THEN '>=300 (severe hyperinsulinemia)'
		ELSE 'Unknown'
	END
ORDER BY category_index DESC;
/*
The diabetes rate increases consistently across the medically defined insulin ranges: 
patients with mild, moderate, and severe hyperinsulinemia show progressively higher 
diabetes prevalence compared to those in the normal range. This suggests a strong 
relationship between insulin dysregulation and diabetes risk.

However, the severe hyperinsulinemia category contains relatively few patients, so 
its observed rate should be interpreted cautiously. Additionally, a large portion 
of the dataset has non-clinical or missing insulin values, limiting the reliability 
of conclusions drawn from this variable.
*/

SELECT 
	outcome, 
	AVG(insulin) AS avg_insulin
	FROM patients_diabetes_clean
GROUP BY outcome
/*
The results show that diabetic patients have a substantially higher average 
insulin level compared to non-diabetic patients. This finding is consistent 
with the previous KPI, where higher insulin ranges also showed higher diabetes 
rates. Together, these results indicate a strong association between elevated 
insulin levels and diabetes in this dataset.
*/
