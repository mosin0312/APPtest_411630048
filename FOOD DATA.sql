CREATE DATABASE food_database;
USE food_database;
CREATE TABLE foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(100) NOT NULL,             -- 食物名稱
    alias_name VARCHAR(100),                     -- 俗名/別名
    calories_kcal DECIMAL(6,2),                  -- 熱量/能量(千卡)
    protein_g DECIMAL(6,2),                      -- 蛋白質(克)
    carbohydrate_g DECIMAL(6,2),                 -- 碳水化合物(克)
    fat_g DECIMAL(6,2),                          -- 脂肪(克)
    fiber_g DECIMAL(6,2),                        -- 膳食纖維(克)
    total_sugar_g DECIMAL(6,2),                  -- 糖質總量(克)
    saturated_fat_g DECIMAL(6,2),                -- 飽和脂肪(克)
    cholesterol_mg DECIMAL(6,2),                 -- 膽固醇(毫克)
    sodium_mg DECIMAL(6,2)                       -- 鈉(毫克)
);
SELECT * FROM foods LIMIT 2181;

DELETE FROM foods WHERE id = 4096;


ALTER TABLE foods
ADD COLUMN trans_fat_g DECIMAL(6,2);             -- 反式脂肪(克)

SHOW DATABASES;

ALTER TABLE foods
MODIFY calories_kcal VARCHAR(20),
MODIFY protein_g VARCHAR(20),
MODIFY carbohydrate_g VARCHAR(20),
MODIFY fat_g VARCHAR(20),
MODIFY fiber_g VARCHAR(20),
MODIFY total_sugar_g VARCHAR(20),
MODIFY saturated_fat_g VARCHAR(20),
MODIFY cholesterol_mg VARCHAR(20),
MODIFY sodium_mg VARCHAR(20),
MODIFY trans_fat_g VARCHAR(20);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/foods_data_utf8_final_clean.csv'
INTO TABLE foods
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(food_name, alias_name, calories_kcal, protein_g, carbohydrate_g, fat_g,
 fiber_g, total_sugar_g, saturated_fat_g, cholesterol_mg, sodium_mg, trans_fat_g);
 
TRUNCATE TABLE foods;
SELECT COUNT(*) FROM foods;

ALTER TABLE foods
  MODIFY calories_kcal DECIMAL(8,2),
  MODIFY protein_g DECIMAL(8,2),
  MODIFY carbohydrate_g DECIMAL(8,2),
  MODIFY fat_g DECIMAL(8,2),
  MODIFY fiber_g DECIMAL(8,2),
  MODIFY total_sugar_g DECIMAL(8,2),
  MODIFY saturated_fat_g DECIMAL(8,2),
  MODIFY cholesterol_mg DECIMAL(8,2),
  MODIFY sodium_mg DECIMAL(8,2),
  MODIFY trans_fat_g DECIMAL(8,2);

ALTER TABLE foods
ADD calcium_mg DECIMAL(8,2) NULL,
ADD iron_mg DECIMAL(8,2) NULL,
ADD magnesium_mg DECIMAL(8,2) NULL,
ADD zinc_mg DECIMAL(8,2) NULL;





SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT food_name, alias_name) AS unique_rows
FROM foods;


SELECT MAX(id) FROM foods;


CREATE TEMPORARY TABLE nutrient_temp (
    calcium_mg DECIMAL(8,2),
    magnesium_mg DECIMAL(8,2),
    iron_mg DECIMAL(8,2),
    zinc_mg DECIMAL(8,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/new.csv'
INTO TABLE nutrient_temp
CHARACTER SET big5
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@calcium, @magnesium, @iron, @zinc)
SET 
  calcium_mg   = NULLIF(TRIM(@calcium), ''),
  magnesium_mg = NULLIF(TRIM(@magnesium), ''),
  iron_mg      = NULLIF(TRIM(@iron), ''),
  zinc_mg      = NULLIF(TRIM(@zinc), '');

SELECT * FROM nutrient_temp LIMIT 2181;
SET SQL_SAFE_UPDATES = 0;

-- 再執行你的 UPDATE 語句
UPDATE nutrient_temp
SET
  calcium_mg = CAST(REGEXP_REPLACE(calcium_mg, '[^0-9.]', '') AS DECIMAL(8,2)),
  magnesium_mg = CAST(REGEXP_REPLACE(magnesium_mg, '[^0-9.]', '') AS DECIMAL(8,2)),
  iron_mg = CAST(REGEXP_REPLACE(iron_mg, '[^0-9.]', '') AS DECIMAL(8,2)),
  zinc_mg = CAST(REGEXP_REPLACE(zinc_mg, '[^0-9.]', '') AS DECIMAL(8,2));

SET SQL_SAFE_UPDATES = 1;

-- 初始化 row 編號變數
SET @row1 := 0;
SET @row2 := 0;

-- 建立 temp_nutrients 暫存表
CREATE TEMPORARY TABLE temp_nutrients AS
SELECT 
  (@row1 := @row1 + 1) AS rownum,
  calcium_mg,
  magnesium_mg,
  iron_mg,
  zinc_mg
FROM nutrient_temp;

-- 建立 temp_foods 暫存表
CREATE TEMPORARY TABLE temp_foods AS
SELECT 
  id,
  (@row2 := @row2 + 1) AS rownum
FROM foods;

-- 執行更新
UPDATE foods f
JOIN temp_foods tf ON f.id = tf.id
JOIN temp_nutrients tn ON tf.rownum = tn.rownum
SET
  f.calcium_mg = tn.calcium_mg,
  f.magnesium_mg = tn.magnesium_mg,
  f.iron_mg = tn.iron_mg,
  f.zinc_mg = tn.zinc_mg;
  
  -- 步驟 1：初始化 row 編號變數
SET @row1 := 0;
SET @row2 := 0;

-- 步驟 2：建立 nutrient_temp 的 rownum 對照表
CREATE TEMPORARY TABLE temp_nutrients AS
SELECT 
  (@row1 := @row1 + 1) AS rownum,
  calcium_mg,
  magnesium_mg,
  iron_mg,
  zinc_mg
FROM nutrient_temp;

-- 步驟 3：建立 foods 的 rownum 對照表
CREATE TEMPORARY TABLE temp_foods AS
SELECT 
  id,
  (@row2 := @row2 + 1) AS rownum
FROM foods;

-- 步驟 4：根據順序對應更新
UPDATE foods f
JOIN temp_foods tf ON f.id = tf.id
JOIN temp_nutrients tn ON tf.rownum = tn.rownum
SET
  f.calcium_mg = tn.calcium_mg,
  f.magnesium_mg = tn.magnesium_mg,
  f.iron_mg = tn.iron_mg,
  f.zinc_mg = tn.zinc_mg;

SELECT * FROM foods LIMIT 2200;

