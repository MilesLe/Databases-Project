-- Q9B.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q9B //

CREATE PROCEDURE Q9B(IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  With priceStartSectors as (
        Select ticker, date_, closePrice as 'startPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK(weekDateStart)
        ),
  priceEndSectors as (
        Select ticker, date_, closePrice as 'endPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK(weekDateEnd)
        ),
  greenSectors as (
        Select s.ticker
        From priceStartSectors as s, priceEndSectors as e
        Where s.ticker = e.ticker and s.startPrice < e.endPrice
        Group by s.ticker
        ),
  comps as (Select c.sector, c.company, count(c.company) as 'num'
        From greenSectors as g, Company as c
        Where g.ticker = c.sector and (c.gender != 'Male' or c.race != 'White')
        )
  Select (c1.num/count(c2.company))*100 as "percent"
  From comps as c1, Company as c2;
END; //

DELIMITER ;
