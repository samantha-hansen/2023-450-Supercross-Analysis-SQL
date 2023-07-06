/*

AMA/Monster Energy Supercross 450 Class Data Exploration

Data utilized to make picks for an online fantasy team. Player is provided with riders' practice times
and tasked with assigning four riders to their team. One rider must be considered an "All Star" and is ranked in 
the top 8 of the seasonwide class standings. Any riders who are not all stars, will accumulate points based 
on their handicap adjusted placing. For example, if a rider is in 20th place but has a handicap of 15, they 
earn 5th place points. Additionally, if a rider's handicap places them in the top ten and they are not an all star 
rider, their point values will be doubled. Players also have the opportunity to earn extra points by picking the 
rider who will be the first lap leader. If they choose correctly, 15 points will be added to their total point 
value. If they choose incorrectly, 7 points will be deducted from their total point value.

Concepts utilized: Aggregate functions, Joins, Descriptive statistics 
*/

-- Show race winners from each race
SELECT * 
FROM results
WHERE Finish = 1;

-- Select certain rider to examine season breakdown
SELECT *
FROM results 
WHERE Rider_Name = 'Chase Sexton';

-- Display count of distinct bike make
-- Possible insight: Is there a 'Best Dirtbike' for supercross competition? 
SELECT DISTINCT Bike_Make, COUNT(Bike_Make)
FROM results
GROUP BY Bike_Make 
ORDER BY COUNT(Bike_Make) DESC;

-- Display count of races by state
SELECT Race_State, COUNT(Race_State)
FROM raceinfo
GROUP BY Race_State
ORDER BY COUNT(Race_State) DESC;

-- Display races where weather was cloudy and elevation is above 1000 ft
SELECT *
FROM raceinfo
WHERE Weather = 'cloudy' AND Elevation > 1000;

-- Display race results from races with high elevation (>4000ft)
-- Possible insight: Most training is done at lower elevation thus higher elevation may impact riders not used to the conditions
SELECT i.Race_ID 'Race ID', 
	i.Race_Name 'Race Name', 
    i.Race_State 'Race State', 
    i.elevation 'Elevation', 
    r.Rider_Name 'Rider Name', 
    r.Finish 'Finish Placing'
FROM raceinfo i
JOIN (
	SELECT Race_ID, Race_Name, Race_State, Rider_Name, Finish
    FROM results 
) r ON i.Race_ID = r.Race_ID 
WHERE i.Elevation > 4000;

-- Display results and fantasy results in races that had rainy weather
-- Possible insight: Do certain riders have abnormally high fantasy scores due to their ability to ride in adverse conditions?
SELECT i.Race_ID, i.weather, r.Rider_Name, r.Finish, r.Fantasy_Points, r.Fantasy_Handicap
FROM raceinfo i
JOIN (
	SELECT Race_ID, Rider_Name, Finish, Fantasy_Points, Fantasy_Handicap
    FROM results 
) r ON i.Race_ID = r.Race_ID 
WHERE i.weather = 'rainy'
ORDER BY Fantasy_Points DESC;

-- Calculate rider season statistics and averages
SELECT DISTINCT(rider_name) 'Rider Name', 
	AVG(finish) 'Average Finish', 
    AVG(Qualifying) 'Average Qualifying', 
    SUM(Points) 'Season Points',
    AVG(Fantasy_Points) 'Average Fantasy Points', 
    SUM(Fantasy_Points) 'Total Fantasy Points'
FROM results
GROUP BY Rider_Name
ORDER BY SUM(Points) DESC;

-- Compare differences in qualifying placing and finish placing
-- Possible insight: Fantasy teams can be picked after practice times have been reported. 
-- 		Finding links between practice times and final placing could improve fantasy choices
SELECT Race_ID 'Race ID',
	rider_name 'Rider Name', 
	qualifying 'Qualifying Placing', 
    finish 'Final Placing', 
    (qualifying - finish) 'Difference b/t Qualifying and Finish'
FROM results;

-- Compare qualifying, first lap, and finish placing among holeshot winners
-- 'Holeshot' refers to the rider who reaches the first turn in first place
-- Extra fantasy points can be gained by correctly choosing a first lap leader
SELECT Race_ID 'Race ID',
	rider_name 'Rider Name',
    qualifying 'Qualifying Placing',
    first_lap_standing 'First Lap Placing',
    finish 'Finish Placing'
FROM results
WHERE Holeshot = 'X';
