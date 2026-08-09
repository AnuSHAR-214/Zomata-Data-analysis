 USE ZomatoProject;
GO

SELECT COUNT(*) FROM Zomato_Data ;
SELECT TOP 5 * FROM Zomato_Data;   

-- Avg rating and cost by location
CREATE VIEW vw_LocationSummary AS
SELECT Location,
       COUNT(*) AS RestaurantCount,
       AVG(Rating) AS AvgRating,
       AVG(Approx_cost_for_two) AS AvgCost
FROM Zomato_Data
WHERE Rating IS NOT NULL
GROUP BY Location;

-- Top cuisines
CREATE VIEW vw_CuisinePopularity AS
SELECT Cuisines, COUNT(*) AS Count, AVG(Rating) AS AvgRating
FROM Zomato_Data
GROUP BY Cuisines;

-- Online order vs rating impact
CREATE VIEW vw_OnlineOrderImpact AS
SELECT Online_Order, AVG(Rating) AS AvgRating, AVG(Votes) AS AvgVotes
FROM Zomato_Data
GROUP BY Online_Order;
