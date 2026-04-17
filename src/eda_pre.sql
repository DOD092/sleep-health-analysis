CREATE DATABASE Sleep_health
GO

USE Sleep_health
GO

--CHECK TABLE NAME
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE'-- data

SELECT TOP 10*
FROM data

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='data'
AND COLUMN_NAME='Sleep_Duration'--FLOAT

UPDATE data
SET SLEEP_DURATION=SLEEP_DURATION/10.0

SELECT TOP 10*
FROM data

SELECT COUNT(*)
FROM data--314

SELECT Sleep_Disorder, COUNT(*)
FROM data
GROUP BY Sleep_Disorder --INSOMNIA 77, NONE 219, SLEEP APNEA 78

SELECT GENDER, COUNT(*) AS TOTAL
FROM data
GROUP BY GENDER --FEMALE 185, MALE 189

SELECT AGE, COUNT(*) AS TOTAL
FROM data
GROUP BY AGE -- FROM 27 TO 59

--CHECK NULL
SELECT
    SUM(CASE WHEN SLEEP_DISORDER IS NULL THEN 1 ELSE 0 END) AS MISSING_DISORDER,
    SUM(CASE WHEN GENDER IS NULL THEN 1 ELSE 0 END) AS MISSING_GENDER,
    SUM(CASE WHEN AGE IS NULL THEN 1 ELSE 0 END) AS MISSING_AGE,
    SUM(CASE WHEN OCCUPATION IS NULL THEN 1 ELSE 0 END) AS MISSING_OCCUPATION,
    SUM(CASE WHEN SLEEP_DURATION IS NULL THEN 1 ELSE 0 END) AS MISSING_SLEEP_DURATION,
    SUM(CASE WHEN QUALITY_OF_SLEEP IS NULL THEN 1 ELSE 0 END) AS MISSING_QUALITY_OF_SLEEP,
    SUM(CASE WHEN PHYSICAL_ACTIVITY_LEVEL IS NULL THEN 1 ELSE 0 END) AS MISSING_PHYSICAL_ACTIVITY_LEVEL,
    SUM(CASE WHEN STRESS_LEVEL IS NULL THEN 1 ELSE 0 END) AS MISSING_STRESS_LEVEL,
    SUM(CASE WHEN BMI_CATEGORY IS NULL THEN 1 ELSE 0 END) AS MISSING_BMI_CATEGORY,  
    SUM(CASE WHEN BLOOD_PRESSURE IS NULL THEN 1 ELSE 0 END) AS MISSING_BLOOD_PRESSURE,
    SUM(CASE WHEN HEART_RATE IS NULL THEN 1 ELSE 0 END) AS MISSING_HEART_RATE,
    SUM(CASE WHEN DAILY_STEPS IS NULL THEN 1 ELSE 0 END) AS MISSING_DAILY_STEPS
FROM data-- NOT NULL
--

SELECT SLEEP_DISORDER, COUNT(*) AS TOTAL
FROM data
GROUP BY Sleep_Disorder
ORDER BY TOTAL DESC

SELECT 
	MIN(AGE) AS MIN, MAX(AGE) AS MAX, AVG(AGE) AS AVG
FROM data-- 27, 59, 42

SELECT
	MIN(SLEEP_DURATION) AS MIN, MAX(SLEEP_DURATION) AS MAX, AVG(SLEEP_DURATION) AS AVG
FROM data-- 0.6, 8.5, 6.434

SELECT
	MIN(Quality_of_Sleep) AS MIN, MAX(Quality_of_Sleep) AS MAX, AVG(Quality_of_Sleep) AS AVG
FROM data-- 4, 9, 7

SELECT
	MIN(PHYSICAL_ACTIVITY_LEVEL) AS MIN, MAX(PHYSICAL_ACTIVITY_LEVEL) AS MAX, AVG(PHYSICAL_ACTIVITY_LEVEL) AS AVG
FROM data-- 30, 90, 59

SELECT
	MIN(STRESS_LEVEL) AS MIN, MAX(STRESS_LEVEL) AS MAX, AVG(STRESS_LEVEL) AS AVG
FROM data-- 3, 8, 5

SELECT
	MIN(HEART_RATE) AS MIN, MAX(HEART_RATE) AS MAX, AVG(HEART_RATE) AS AVG
FROM data-- 65, 86, 70

SELECT
	MIN(DAILY_STEPS) AS MIN, MAX(DAILY_STEPS) AS MAX, AVG(DAILY_STEPS) AS AVG
FROM data-- 3000, 10000, 6816

SELECT GENDER, CAST(AVG(SLEEP_DURATION) AS FLOAT) AS AVG_SLEEP
FROM data
GROUP BY GENDER-- FEMALE: 6.34, MALE:6.52

SELECT SLEEP_DURATION, COUNT(*) AS TOTAL
FROM data
GROUP BY SLEEP_DURATION 

 SELECT OCCUPATION, AVG(CAST(STRESS_LEVEL AS FLOAT)) AS AVG_STRESS
 FROM data
 GROUP BY OCCUPATION
 ORDER BY AVG_STRESS DESC
 /*
 8: Sale Representative
 7: Salesperson, Scientist
 6: Doctor, Software Engineer
 5: Nurse, Lawyer, Manager
 4: Accountant, Teacher
 3: Engineer
 */

 SELECT BMI_CATEGORY , AVG(SLEEP_DURATION) AS AVG_SLEEP_DURATION
 FROM data
 GROUP BY BMI_Category
 /*
 Normal: 6,89
 Normal Weight: 6.64
 Obese 6.96
 Overweight: 5.76
 */
 
 UPDATE DATA
 SET BMI_Category='Normal'
 WHERE BMI_Category='Normal Weight'

 SELECT BMI_CATEGORY , AVG(SLEEP_DURATION) AS AVG_SLEEP_DURATION
 FROM data
 GROUP BY BMI_Category
 /*
 Normal: 6,87
 Obese: 6.96
 Overweight: 5.76
 */

 SELECT SLEEP_DISORDER, AVG(SLEEP_DURATION) AS AVG_SLEEP_DURATION
 FROM data
 GROUP BY SLEEP_DISORDER
 /*
 Insomnia: 6.52
 None: 6.84
 Sleep Apnea: 5.2
 */

 SELECT PHYSICAL_ACTIVITY_LEVEL, AVG(CAST(QUALITY_OF_SLEEP AS FLOAT)) AS AVG_SLEEP_QUALITY, AVG(CAST(SLEEP_DURATION AS FLOAT)) AS AVG_SLEEP_DURATION, COUNT(*) AS TOTAL
 FROM data
 GROUP BY PHYSICAL_ACTIVITY_LEVEL
 ORDER BY PHYSICAL_ACTIVITY_LEVEL
 /* 
Activity ~30 -> Sleep quality ~7.35, duration ~5.75
Activity ~60 -> Quality ~7.9, duration ~7.19
Activity ~75 -> Quality ~8.01, duration ~6.73	
-> People who have good sleep quality usually do physical activities
 */

 SELECT SLEEP_DISORDER, AVG(PHYSICAL_ACTIVITY_LEVEL) AS AVG_ACTIVITY, COUNT(*) AS TOTAL
 FROM data
 GROUP BY SLEEP_DISORDER

 /*
 Insomnia: 46: 77
 None: 57: 219
 Sleep Apnea: 74: 78
 -> x<46 and x>74 = sleep disorder
 */

 SELECT SLEEP_DISORDER, AVG(STRESS_LEVEL) AS AVG_STRESS_LEVEL
 FROM data
 GROUP BY SLEEP_DISORDER


 SELECT GENDER, SLEEP_DISORDER, COUNT(*) AS TOTAL
 FROM data
 GROUP BY GENDER, SLEEP_DISORDER
 ORDER BY GENDER
 /*
 FEMALE: Sleep Apnea(67) > Insomnia(36)
 MALE: Insomnia(41) > Sleep Apnea(11)
 MALE(137) usually dont be sleep disorder than female(82)
 */

 SELECT GENDER, PHYSICAL_ACTIVITY_LEVEL, COUNT(*) AS TOTAL
 FROM data
 GROUP BY GENDER, PHYSICAL_ACTIVITY_LEVEL
 ORDER BY GENDER
 /*
 Female and Male <45
 Female and Male > 60
 */

 SELECT GENDER, STRESS_LEVEL, COUNT(*) AS TOTAL
 FROM data
 GROUP BY GENDER, STRESS_LEVEL
 ORDER BY GENDER
 /*
 Female:3,4 and some people stress at level 8(34)
 Male >5
 */
 SELECT OCCUPATION, SLEEP_DURATION, COUNT(*) AS TOTAL
 FROM data
 GROUP BY OCCUPATION, SLEEP_DURATION
 ORDER BY OCCUPATION

 SELECT OCCUPATION, AVG(SLEEP_DURATION) AS AVG_SLEEP_DURATION
 FROM data
 GROUP BY OCCUPATION
 ORDER BY OCCUPATION
 /*
 Engineer~8, Lawyer: 7.4, Manager: 6.9
 Nurse~5
 */


SELECT HEART_RATE, COUNT(*) AS total
FROM data
GROUP BY HEART_RATE
ORDER BY HEART_RATE
/*
~65-75 ROUND HERE
76-86 NOT TO MUCH PEOPLE
*/

 SELECT SLEEP_DISORDER, AVG(HEART_RATE) AS AVG_HEART_RATE
 FROM data
 GROUP BY SLEEP_DISORDER
 ORDER BY SLEEP_DISORDER

SELECT 
    CASE 
        WHEN HEART_RATE < 60 THEN 'Low'
        WHEN HEART_RATE BETWEEN 60 AND 80 THEN 'Normal'
        ELSE 'High'
    END AS heart_rate_group,
    COUNT(*) AS total
FROM data
GROUP BY 
    CASE 
        WHEN HEART_RATE < 60 THEN 'Low'
        WHEN HEART_RATE BETWEEN 60 AND 80 THEN 'Normal'
        ELSE 'High'
    END
/*
High: 12-> outlier
Normal: 362
*/

SELECT 
    Physical_Activity_Level,
    AVG(Heart_Rate) AS avg_heart_rate,
    COUNT(*) AS total
FROM data
GROUP BY Physical_Activity_Level
ORDER BY Physical_Activity_Level
/*
Activity low (~30) -> heart rate ~68
Activity normal (~60) -> ~68
Activity high (~75) -> ~69
Activity veryhigh (~90) -> ~72
--> Heart rate is stable with activity
*/

SELECT 
    BMI_Category,
    Sleep_Disorder,
    COUNT(*) AS total
FROM data
GROUP BY BMI_Category, Sleep_Disorder
ORDER BY BMI_Category
/*
Normal: usually None~90%
Obese: 4 for Insomnia and 6 for Sleep Apnea 
Overweight: 64 for Insomnia and 65 for Sleep Apnea
*/


--Test seperate column
SELECT 
    Blood_Pressure,
    LEFT(Blood_Pressure, CHARINDEX('/', Blood_Pressure) - 1) AS Systolic,
    RIGHT(Blood_Pressure, LEN(Blood_Pressure) - CHARINDEX('/', Blood_Pressure)) AS Diastolic
FROM data;


--UPDATE COLUMNS Systolic and Diastolic
ALTER TABLE data
ADD Systolic INT, Diastolic INT

UPDATE data
SET 
    Systolic = CAST(LEFT(Blood_Pressure, CHARINDEX('/', Blood_Pressure) - 1) AS INT),
    Diastolic = CAST(RIGHT(Blood_Pressure, LEN(Blood_Pressure) - CHARINDEX('/', Blood_Pressure)) AS INT)



-- Systolic, Diastolic for preview
SELECT 
    Systolic,
    Diastolic,
    CASE 
        WHEN Systolic < 130 AND Diastolic < 85 THEN 'Normal'
        WHEN (Systolic BETWEEN 130 AND 139) OR (Diastolic BETWEEN 85 AND 89) THEN 'High-normal'
        WHEN (Systolic BETWEEN 140 AND 159) OR (Diastolic BETWEEN 90 AND 99) THEN 'Grade 1 hypertension'
        WHEN Systolic >= 160 OR Diastolic >= 100 THEN 'Grade 2 hypertension'
        ELSE 'Unknown'
    END AS Blood_Pressure_Category
FROM data

SELECT 
    Blood_Pressure_Category,
    Sleep_Disorder,
    COUNT(*) AS total
FROM (
    SELECT 
        Sleep_Disorder,
        CASE 
            WHEN Systolic < 130 AND Diastolic < 85 THEN 'Normal'
            WHEN (Systolic BETWEEN 130 AND 139) OR (Diastolic BETWEEN 85 AND 89) THEN 'High-normal'
            WHEN (Systolic BETWEEN 140 AND 159) OR (Diastolic BETWEEN 90 AND 99) THEN 'Grade 1 hypertension'
            WHEN Systolic >= 160 OR Diastolic >= 100 THEN 'Grade 2 hypertension'
            ELSE 'Unknown'
        END AS Blood_Pressure_Category
    FROM data
) t
GROUP BY Blood_Pressure_Category, Sleep_Disorder


--UPDATE COLUMN Blood_Pressure_Category
ALTER TABLE data
ADD Blood_Pressure_Category NVARCHAR(50)

UPDATE data
SET Blood_Pressure_Category =
    CASE 
        WHEN Systolic < 130 AND Diastolic < 85 THEN 'Normal'
        WHEN (Systolic BETWEEN 130 AND 139) OR (Diastolic BETWEEN 85 AND 89) THEN 'High-normal'
        WHEN (Systolic BETWEEN 140 AND 159) OR (Diastolic BETWEEN 90 AND 99) THEN 'Grade 1 hypertension'
        WHEN Systolic >= 160 OR Diastolic >= 100 THEN 'Grade 2 hypertension'
        ELSE 'Unknown'
    END


--CHECK
SELECT TOP 20
    Blood_Pressure,
    Systolic,
    Diastolic,
    Blood_Pressure_Category
FROM data;

--CHECK NULL 
SELECT 
    SUM(CASE WHEN Systolic IS NULL THEN 1 ELSE 0 END) AS null_systolic,
    SUM(CASE WHEN Diastolic IS NULL THEN 1 ELSE 0 END) AS null_diastolic,
    SUM(CASE WHEN Blood_Pressure_Category IS NULL THEN 1 ELSE 0 END) AS null_bp_category
FROM data;

--CHECK 
SELECT 
    Blood_Pressure_Category,
    COUNT(*) AS total
FROM data
GROUP BY Blood_Pressure_Category
ORDER BY total DESC;

SELECT TOP 10*
FROM DATA

SELECT * FROM data;