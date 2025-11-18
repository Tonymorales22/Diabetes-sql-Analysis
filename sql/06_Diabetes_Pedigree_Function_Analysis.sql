-- KPI: Diabetes rate by diabetes pedigree function ranges 
SELECT
    CASE
        WHEN dpf BETWEEN 0 AND 0.4 THEN '0-0.4 (low risk)'
        WHEN dpf BETWEEN 0.4 AND 0.8 THEN '0.4-0.8 (medium risk)'
        WHEN dpf BETWEEN 0.8 AND 1.2 THEN '0.8-1.2 (High risk)'
        WHEN dpf > 1.2 THEN '>1.2 (Very High risk)'
        ELSE 'Unknown'
    END AS diabetes_pedigree_function_range,
    
    COUNT(*) AS total_patients,
    SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,

    -- Probability of diabetes in this dpf range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
    FROM(
        SELECT 
        diabetes_pedigree_function AS dpf,
        outcome AS outcome
        FROM patients_diabetes_clean
     )AS t
WHERE dpf IS NOT NULL
GROUP BY
    CASE
        WHEN dpf BETWEEN 0 AND 0.4 THEN '0-0.4 (low risk)'
        WHEN dpf BETWEEN 0.4 AND 0.8 THEN '0.4-0.8 (medium risk)'
        WHEN dpf BETWEEN 0.8 AND 1.2 THEN '0.8-1.2 (High risk)'
        WHEN dpf > 1.2 THEN '>1.2 (Very High risk)'
        ELSE 'Unknown'
    END
ORDER BY diabetes_rate DESC;
/*
The results show a clear pattern: higher DPF values are associated with 
higher diabetes rates. Patients in the lowest range (0–0.4) have the 
lowest diabetes prevalence, while those with DPF values above 1.2 show 
the highest proportion of diabetes cases.

This is consistent with the medical interpretation of the DPF, since it 
captures genetic risk factors and family history of diabetes. Although 
the dataset is relatively small, the trend is strong and consistent 
across all ranges.

*/

--kpi: avg dpf in diabetic/non diabetic patients
SELECT
    outcome,
    AVG(diabetes_pedigree_function) AS 'avg diabetes pedigree function',
    COUNT(*) AS 'total patients'
    FROM patients_diabetes_clean
GROUP BY outcome
/*
This query shows that diabetic patients have, on average, a higher 
Diabetes Pedigree Function (DPF). This result is consistent with the 
previous KPI, where the highest DPF ranges also showed the highest 
diabetes rates. Together, both metrics reinforce the relationship 
between hereditary risk factors and diabetes in this dataset.
*/
