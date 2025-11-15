--KPIs : Quantity of patients with or  without obestity
-- BMI critical umbral 
SELECT
    CASE
        WHEN bmi < 18.5 THEN '<18.5 (Bajo peso)'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN '18.5 - 24.9 (Peso saludable)'
        WHEN bmi BETWEEN 25 AND 29.9 THEN '25 - 29.9 (Sobrepeso)'
        WHEN bmi BETWEEN 30 AND 34.9 THEN '30 - 34.9 (Obesidad tipo 1)'
        WHEN bmi BETWEEN 35 AND 39.9 THEN '35- 39.9 (Obesidad tipo 2)'
        WHEN bmi >= 40 THEN '>=40 (Obesidad severa)'
        ELSE 'Unknown'
    END AS standar_medical_classification,
    CASE
        WHEN bmi < 18.5 THEN 1
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 2
        WHEN bmi BETWEEN 25 AND 29.9 THEN 3
        WHEN bmi BETWEEN 30 AND 34.9 THEN 4
        WHEN bmi BETWEEN 35 AND 39.9 THEN 5
        WHEN bmi >= 40 THEN 6
        ELSE 0
    END AS category_index,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,

    -- Probability of diabetes in this bmi range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
FROM patients_diabetes_clean
WHERE bmi IS NOT NULL
GROUP BY 
    CASE
        WHEN bmi < 18.5 THEN '<18.5 (Bajo peso)'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN '18.5 - 24.9 (Peso saludable)'
        WHEN bmi BETWEEN 25 AND 29.9 THEN '25 - 29.9 (Sobrepeso)'
        WHEN bmi BETWEEN 30 AND 34.9 THEN '30 - 34.9 (Obesidad tipo 1)'
        WHEN bmi BETWEEN 35 AND 39.9 THEN '35- 39.9 (Obesidad tipo 2)'
        WHEN bmi >= 40 THEN '>=40 (Obesidad severa)'
        ELSE 'Unknown'
    END,

    CASE
        WHEN bmi < 18.5 THEN 1
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 2
        WHEN bmi BETWEEN 25 AND 29.9 THEN 3
        WHEN bmi BETWEEN 30 AND 34.9 THEN 4
        WHEN bmi BETWEEN 35 AND 39.9 THEN 5
        WHEN bmi >= 40 THEN 6
        ELSE 0
    END
ORDER BY category_index DESC

/*
Most patients in the dataset fall within the “Obesity Type I” category. 
Diabetes rates increase progressively across BMI categories, with a notable 
jump occurring at the 30–34.9 range. In this interval, the diabetes rate 
is roughly double that of the previous BMI category (≈45% vs ≈22%). 

This suggests that BMI ≥30 represents a clinically relevant threshold 
where diabetes risk increases sharply.
*/

--KPI: AVG BMI per diabetic/non diabetic patient
SELECT 
	outcome,
	AVG(bmi) AS avg_bmi,
	COUNT(*) AS total_patients
	FROM patients_diabetes_clean
WHERE bmi IS NOT NULL
GROUP BY outcome
ORDER BY avg_bmi DESC;
/*
Diabetic patients show slightly higher average BMI compared to 
non-diabetic patients. However, the difference is moderate, indicating 
that BMI alone is not as strong or discriminative a predictor as glucose. 

While elevated BMI contributes to diabetes risk, it should not be treated 
as a standalone determinant, but rather as one factor among several.
*/
