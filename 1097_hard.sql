# 1097. Game Play Analysis V

# Table: Activity

# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | player_id    | int     |
# | device_id    | int     |
# | event_date   | date    |
# | games_played | int     |
# +--------------+---------+
# (player_id, event_date) is the primary key of this table.
# This table shows the activity of players of some game.
# Each row is a record of a player who logged in and played a number of games (possibly 0) 
# before logging out on some day using some device.
 

# We define the install date of a player to be the first login day of that player.

# We also define day 1 retention of some date X to be the number of players whose 
# install date is X and they logged back in on the day right after X, divided by 
# the number of players whose install date is X, rounded to 2 decimal places.

# Write an SQL query that reports for each install date, the number of players that 
# installed the game on that day and the day 1 retention.

WITH Install AS (
    SELECT player_id, MIN(event_date) AS install_date
    FROM Activity
    GROUP BY player_id
)

SELECT 
    I.install_date AS install_dt,
    COUNT(I.player_id) AS installs,
    CAST(COUNT(A.event_date)*1.0/COUNT(I.player_id) AS DECIMAL(10,2)) AS Day1_retention
FROM Install I
LEFT JOIN Activity A
    ON I.player_id = A.player_id
        AND I.install_date = DATEADD(day, -1, A.event_date)
GROUP BY I.install_date
