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
SELECT * FROM foods LIMIT 2180;


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



