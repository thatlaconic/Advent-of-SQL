--sql advent challenge day 1

SELECT *
FROM children;

SELECT *
FROM toy_catalogue;

SELECT *
FROM wish_lists;

SELECT table_name, column_name, data_type, is_nullable, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'children' or table_name = 'toy_catalogue' or table_name = 'wish_lists'
ORDER BY table_name;

--final answer
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
LIMIT 5
;

