-- CREATE DATABASE laptopsdb;
USE laptopsdb;
# INSPECTING COLUMNS
SELECT * FROM laptops;

-- Q1. Creating Backup of Data
CREATE TABLE laptop_backup LIKE laptops;

# Inserting all the data to newly created table
INSERT INTO laptop_backup 
SELECT * FROM laptops;

# Checking whether data is inserted properly or not
SELECT * FROM laptop_backup;


#################################################################
-- Q2. Check number of rows
SELECT COUNT(*) FROM laptops;

#################################################################
-- Q3. Check memory consumption for reference
SELECT ROUND(DATA_LENGTH/1024) AS "memory consumption IN kb" FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptopsdb' AND TABLE_NAME = 'laptops';

#################################################################
-- Q4. Drop non-important columns
SELECT * FROM laptops;

ALTER TABLE laptops DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptops;

#################################################################
-- Q5. Drop null values
DELETE FROM laptops
WHERE Company IS NULL
  AND TypeName IS NULL
  AND Inches IS NULL
  AND ScreenResolution IS NULL
  AND Cpu IS NULL
  AND Ram IS NULL
  AND Memory IS NULL
  AND Gpu IS NULL
  AND OpSys IS NULL
  AND Weight IS NULL
  AND Price IS NULL;

#################################################################
-- Q6. Drop Duplicate values
SELECT *
FROM laptops
GROUP BY `Index`, Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price
HAVING COUNT(*) > 1;

DELETE FROM laptops
WHERE `Index` NOT IN (SELECT MIN(`Index`)
FROM laptops
GROUP BY `Index`, Company, TypeName, Inches, ScreenResolution, 
Cpu, Ram, Memory, Gpu, OpSys, Weight, Price);


#################################################################
						-- DATA CLEANING --
#################################################################
-- Q7. Check missing values of column AND chnage data type
SELECT * FROM laptops;

-- Company
SELECT DISTINCT(Company) FROM laptops;
-- ------------------------------------------------------
-- TypeName
SELECT DISTINCT(TypeName) FROM laptops;
-- ------------------------------------------------------
-- Inches
SELECT DISTINCT(Inches) FROM laptops;
		-- type conversion
ALTER TABLE laptops
MODIFY COLUMN Inches DECIMAL(10,1);

SELECT Inches FROM laptops;
-- ------------------------------------------------------
-- Ram(remove GB text from Column)
SELECT DISTINCT(Ram) FROM laptops;

UPDATE laptop L1
SET Ram = (SELECT REPLACE(Ram, 'GB','') FROM laptops L2 WHERE L2.index = L1.index);

-- OR
UPDATE laptops SET Ram = REPLACE(Ram, 'GB', '');

-- MODIFY IT TO int
ALTER TABLE laptops 
MODIFY COLUMN Ram INTEGER;
-- ------------------------------------------------------
-- Weight
SELECT DISTINCT(Weight) FROM laptops;

-- REMOVE KG text from data
UPDATE laptops SET Weight = REPLACE(Weight, 'kg', "");
-- OR 
UPDATE laptops L1
SET Weight = (SELECT REPLACE(Weight, "kg", "") FROM laptops L2 WHERE L2.index = L1.index);

-- there is issue that one row contains wt = "?" we have to replace it to actual weight
-- lets find it out firts
SELECT * FROM laptops
WHERE Weight = "?";
-- replacing it to actual value 1.22
UPDATE laptops
SET Weight = 1.22
WHERE Weight = "?" AND Company = "Dell" AND TypeName = 'Ultrabook';

-- MODIFY IT TO int
ALTER TABLE laptops
MODIFY COLUMN Weight INTEGER;

-- ------------------------------------------------------
-- Price (lets round off the price)
UPDATE laptops L1
JOIN (
    SELECT `Index`, ROUND(Price) AS RoundedPrice
    FROM laptops
) AS L2 ON L1.`Index` = L2.`Index`
SET L1.Price = L2.RoundedPrice;

-- MODIFY IT TO int
ALTER TABLE laptops
MODIFY COLUMN Price INTEGER;

-- ------------------------------------------------------
-- OpSys (Lets create now column for os with following categories)
 
/* 
- mac
- Windows
- Linux
- no os
- others (Android, Chrome os)
*/

SELECT OpSys, 
	CASE
		WHEN OpSys LIKE "%mac%" THEN "mac"
		WHEN OpSys LIKE "%windows%" THEN "windows"
		WHEN OpSys LIKE "%linux%" THEN "linux"
		WHEN OpSys = "No OS" THEN "N/A"
		ELSE 'other'
	END AS "os_brand" 
FROM laptops;

-- Now replacing OpSys column with os_brand
UPDATE laptops
SET OpSys = CASE
		WHEN OpSys LIKE "%mac%" THEN "mac"
		WHEN OpSys LIKE "%windows%" THEN "windows"
		WHEN OpSys LIKE "%linux%" THEN "linux"
		WHEN OpSys = "No OS" THEN "N/A"
		ELSE 'other'
	END;

-- ------------------------------------------------------
-- Gpu (Lets create 2 column for Gpu brand_name and name of GUP)

ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER  gpu_brand;

-- lets insert values in newly created columns
UPDATE laptops AS L1
JOIN laptops AS L2 ON L1.`Index` = L2.`Index`
SET L1.gpu_brand = SUBSTRING_INDEX(L2.Gpu, ' ', 1);

/* you can use this query as well
UPDATE laptops L1
JOIN (
    SELECT `Index`, SUBSTRING_INDEX(Gpu, ' ', 1) AS gpu_brand
    FROM laptops
) AS L2 ON L1.`Index` = L2.`Index`
SET L1.gpu_brand = L2.gpu_brand;
 
*/

-- INSERTING VALUES TO gpu_name
UPDATE laptops L1
JOIN (
    SELECT `Index`, REPLACE(Gpu, gpu_brand, '') AS gpu_name
    FROM laptops
) AS L2 ON L1.`Index` = L2.`Index`
SET L1.gpu_name = L2.gpu_name;

-- DROP Gpu TABLE AS WE DONT NEED IT
ALTER TABLE laptops
DROP COLUMN Gpu;

-- ------------------------------------------------------
-- Cpu (Lets create 2 column for Cpu brand_name and name of Cpu AND SPEED GHz)
ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

-- Now insert values IN newly created columns
-- cpu_brand
UPDATE laptops AS L1
JOIN laptops AS L2 ON L1.`Index` = L2.`Index`
SET L1.cpu_brand = SUBSTRING_INDEX(L2.Cpu, ' ', 1);

-- cpu_speed
/*
UPDATE laptops L1
SET cpu_speed = (
    SELECT CAST(REPLACE(SUBSTRING_INDEX(L2.Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10, 2))
    FROM laptops L2
    WHERE L2.`Index` = L1.`Index`
);
*/
UPDATE laptops AS L1
JOIN (
    SELECT `Index`, 
           CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10, 2)) AS cpu_speed
    FROM laptops
) AS L2 ON L1.`Index` = L2.`Index`
SET L1.cpu_speed = L2.cpu_speed;

-- cpu_name
UPDATE laptops AS L1
JOIN (
    SELECT `Index`, 
           REPLACE(REPLACE(Cpu,cpu_brand,''),SUBSTRING_INDEX(REPLACE(Cpu,cpu_brand,''),' ',-1),'') AS cpu_name
    FROM laptops
) AS L2 ON L1.`Index` = L2.`Index`
SET L1.cpu_name = L2.cpu_name;

-- DROPING categories from cpu_name
UPDATE laptops
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name), " ", 2);

-- DROP UNWANTED COLUMN
ALTER TABLE laptops DROP COLUMN Cpu;

-- ------------------------------------------------------
-- ScreenResolution 
SELECT ScreenResolution, SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, " ", -1), "x",1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, " ", -1), "x",-1)
FROM laptops;

-- CREATE 3 NEW COLUMNS FOR resolution height, width, touchscreen
ALTER TABLE laptops
ADD COLUMN resilution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resilution_height INTEGER AFTER resilution_width,
ADD COLUMN touchscreen INTEGER AFTER resilution_height;

-- INSETING DATA
UPDATE laptops
SET resilution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, " ", -1), "x",1),
resilution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, " ", -1), "x",-1);

SELECT ScreenResolution LIKE "%Touch%" FROM laptops;
UPDATE laptops
SET touchscreen = ScreenResolution LIKE "%Touch%";

-- DROP ScreenResolution COLUMN
ALTER TABLE laptops DROP COLUMN ScreenResolution;


-- ------------------------------------------------------
-- Memory 
-- lets create 3 new columns (memory_type, primary_storage, secondary_storage)

ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER Memory,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

-- Lets insert values in newly created columns

-- memory_type
SELECT Memory,
CASE
	WHEN Memory LIKE "%SSD%" AND Memory LIKE "%HDD%" THEN "Hybrid"
    WHEN Memory LIKE "%SSD%" THEN "SSD"
	WHEN Memory LIKE "%HDD%" THEN "HDD"
    WHEN Memory LIKE "%Flash Storage%" THEN "Flash Storage"
    WHEN Memory LIKE "%Hybrid%" THEN "Hybrid"
    WHEN Memory LIKE "%Flash Storage%" AND Memory LIKE "%HDD%" THEN "Hybrid"
	ELSE NULL
END as "memory_type" FROM laptops;

UPDATE laptops
SET memory_type = CASE
			WHEN Memory LIKE "%SSD%" AND Memory LIKE "%HDD%" THEN "Hybrid"
			WHEN Memory LIKE "%SSD%" THEN "SSD"
			WHEN Memory LIKE "%HDD%" THEN "HDD"
			WHEN Memory LIKE "%Flash Storage%" THEN "Flash Storage"
			WHEN Memory LIKE "%Hybrid%" THEN "Hybrid"
			WHEN Memory LIKE "%Flash Storage%" AND Memory LIKE "%HDD%" THEN "Hybrid"
			ELSE NULL
END;

-- primary_storage,secondary_storage
SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END
FROM laptops;

UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;


-- converting 1 and 2 TB to GB
SELECT 
primary_storage,
CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END
FROM laptops;


UPDATE laptops
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

ALTER TABLE laptops DROP COLUMN Memory;

SELECT * FROM laptops;
