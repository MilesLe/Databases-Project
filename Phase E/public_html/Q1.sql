-- Q1.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q1 //

CREATE PROCEDURE Q1(IN weekDate VARCHAR(255))
BEGIN
  With mondays as (
    Select ticker, date_, closePrice as startPrice
    From SectorETF 
    Where YEARWEEK(date_) = YEARWEEK(weekDate) and dayofweek(date_) = 2
  ),
	fridays as (
    Select ticker, date_, closePrice as endPrice
    From SectorETF
    Where YEARWEEK(date_) = YEARWEEK(weekDate) and dayofweek(date_) = 6
  ),
	bestSector as (
    Select m.ticker, max(endPrice - startPrice) as 'bestDiff', endPrice
    From mondays as m, fridays as f
    Where m.ticker = f.ticker
  )
	Select s.ticker, avg(s.volume) as 'average volume', b.endPrice
	From bestSector as b, SectorETF as s
	Where b.ticker = s.ticker and YEARWEEK(s.date_) = YEARWEEK(weekDate);
END; //

DELIMITER ;
