--KPI: Patients distribution per age range
SELECT
    CASE
        WHEN age < 30 THEN 1
        WHEN age BETWEEN 30 AND 39 THEN 2
        WHEN age BETWEEN 40 AND 49 THEN 3
        WHEN age BETWEEN 50 AND 59 THEN 4
        WHEN age >= 60 THEN 5
        ELSE 0
    END AS category_index,

    CASE
        WHEN age < 30 THEN '<30 (young)'
        WHEN age BETWEEN 30 AND 39 THEN '30-39 (early adults)'
        WHEN age BETWEEN 40 AND 49 THEN '40-49 (intermediate risk adults)'
        WHEN age BETWEEN 50 AND 59 THEN '50-59 (high risk adults)'
        WHEN age >= 60 THEN '>=60 (older adults)'
        ELSE 'Unknown'
    END AS age_range,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN outcome = 0 THEN 1 ELSE 0 END) AS non_diabetic_patients,
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) AS diabetic_patients,
    -- Probability of diabetes in this age range
    SUM(CASE WHEN outcome = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) 
        AS diabetes_rate
    FROM patients_diabetes_clean
WHERE age IS NOT NULL
GROUP BY 
    CASE
        WHEN age < 30 THEN '<30 (young)'
        WHEN age BETWEEN 30 AND 39 THEN '30-39 (early adults)'
        WHEN age BETWEEN 40 AND 49 THEN '40-49 (intermediate risk adults)'
        WHEN age BETWEEN 50 AND 59 THEN '50-59 (high risk adults)'
        WHEN age >= 60 THEN '>=60 (older adults)'
        ELSE 'Unknown'
    END,

    CASE
        WHEN age < 30 THEN 1
        WHEN age BETWEEN 30 AND 39 THEN 2
        WHEN age BETWEEN 40 AND 49 THEN 3
        WHEN age BETWEEN 50 AND 59 THEN 4
        WHEN age >= 60 THEN 5
        ELSE 0
    END
ORDER BY category_index;
/*
Approximately half of the patients in the dataset are younger than 30 years old, 
indicating that the age distribution is heavily skewed toward younger individuals.
It is important to note that the older and higher-risk age groups contain far fewer
patients. As a result, interpretations about these groups should be approached with
caution, as the limited sample size may not fully represent their true clinical risk.
*/
/*
Diabetes rates do not increase linearly with age. The most notable rise occurs 
between the "<30" and "30–39" groups, where the diabetes rate nearly doubles 
(≈21% to ≈46%). 

After that point, the increase slows considerably: from 40 to 59 years old the 
diabetes rate rises only moderately (from ≈46% to ≈59%). Interestingly, patients 
aged 60 or older show a lower diabetes rate (~28%) compared to the 50–59 group.

These patterns suggest that age influences diabetes risk, but not in a strictly 
linear or monotonic fashion. The 30–39 and 40–59 ranges appear to be the most 
clinically relevant transitions.
*/

--kpi: avg age in diabetic/non diabetic patients
SELECT
    outcome,
    AVG(age) AS 'avg age',
    COUNT(*) AS 'total patients'
    FROM patients_diabetes_clean
GROUP BY outcome
/*
The diabetic group is moderately older on average compared to the non-diabetic group.
This difference is consistent with the previous KPIs, where the diabetes rate tended to increase with age. 
However, the gap is not large enough to suggest that age alone is a strong determinant of diabetes within this dataset.
*/
