-- 1194. Tournament Winners

/*
Table: Players
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key of this table.
Each row of this table indicates the group of each player.

Table: Matches
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     | 
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belongs to the same group.
 
The winner in each group is the player who scored the maximum total points within the group. 
In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group.

The query result format is in the following example:

Result table:
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
*/

-- MS SQL with CTE:
WITH player_score AS -- combine the scores in all matches as first and second player for each player
(SELECT 
    COALESCE(M1.player, M2.player) AS player_id,
    COALESCE(M1.total_first, 0) + COALESCE(M2.total_second, 0) AS score
FROM
    (
    SELECT first_player AS player, SUM(first_score) AS total_first
    FROM Matches
    GROUP BY first_player) M1
FULL OUTER JOIN 
    (
    SELECT second_player AS player, SUM(second_score) AS total_second
    FROM Matches
    GROUP BY second_player) M2
    ON M1.player = M2.player
),

player_rank AS -- rank players for each group with window function
(SELECT 
    p.group_id, 
    ps.player_id,
    RANK() OVER(PARTITION BY p.group_id ORDER BY ps.score DESC, ps.player_id ASC) AS rk
FROM player_score ps
LEFT JOIN Players p
    ON ps. player_id = p.player_id
)

SELECT group_id, player_id
FROM player_rank
WHERE rk = 1
;
