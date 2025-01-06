# [Santa's Gift List Parser](https://adventofsql.com/challenges/1)
## Description
Santa's workshop is modernizing! Gone are the days of paper wish lists and manual sorting. The elves have implemented a new digital system to handle the millions of Christmas wishes they receive. However, Santa needs a way to quickly understand what each child wants and how to optimize workshop operations.

## Challenge
[Download Challenge Data](https://github.com/thatlaconic/Advent-of-SQL/blob/main/advent_of_sql_day_1.sql)

Create a report that helps Santa and the elves understand:
* Each child's primary and backup gift choices
* Their color preferences
* How complex each gift is to make where:
    ```
    Simple Gift = 1
    Moderate Gift = 2
    Complex Gift >= 3
    ```
* Which workshop department should handle the creation based on the primary wish's toy category. Assume the following:
  ```
  outdoor = Outside Workshop
  educational = Learning Workshop
  all other types = General Workshop
  ```
* Order the list by name in ascending order and the answer should only return in 5 rows

## Dataset
This dataset contains 3 tables. 
### Using PostgreSQL:
**input**
```sql
SELECT *
FROM children ;
```
**output**
![](https://github.com/thatlaconic/Advent-of-SQL/blob/main/children.PNG)

**input**
```sql
SELECT *
FROM toy_catalogue ;
```
**output**
![](https://github.com/thatlaconic/Advent-of-SQL/blob/main/toy_catalogue.PNG)

**input**
```sql
SELECT *
FROM wish_lists ;
```
**output**
![](https://github.com/thatlaconic/Advent-of-SQL/blob/main/wish_lists.PNG)

## Solution
[Download Solution Code](https://github.com/thatlaconic/Advent-of-SQL/blob/main/advent_answer_day1.sql)

**input** 
```sql
WITH CTE AS (SELECT child_id, wishes->>'first_choice' as first_choice, 
			wishes->>'second_choice' as backup_choice,
			wishes->'colors' as colors
			FROM wish_lists),
CTE2 AS (SELECT child_id, first_choice, backup_choice, 
		colors->>0 AS fav_color,
		COUNT(*) AS color_count
		FROM CTE, json_array_elements(colors)
		GROUP BY child_id, first_choice, backup_choice, fav_color)
SELECT name, first_choice, backup_choice, fav_color, color_count,
		CASE
			WHEN difficulty_to_make = 1 THEN 'Simple Gift'
			WHEN difficulty_to_make = 2 THEN 'Moderate Gift'
			ELSE 'Complex Gift'
		END AS gift_complexity,
		CASE
			WHEN category = 'outdoor' THEN 'Outside Workshop'
			WHEN category = 'educational' THEN 'Learning Workshop'
			ELSE 'General Workshop'
		END AS workshop_assignment
FROM CTE2
JOIN children ON CTE2.child_id = children.child_id
JOIN toy_catalogue ON CTE2.first_choice = toy_catalogue.toy_name
ORDER BY name
LIMIT 5  ;
```
**output**
![](https://github.com/thatlaconic/Advent-of-SQL/blob/main/answer.PNG)
