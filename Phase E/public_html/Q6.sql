-- Q6.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q6 //

CREATE PROCEDURE Q6(IN indexTicker VARCHAR(255), IN bondTicker VARCHAR(255), IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  With mondaysIndex as (
        Select ticker, date_, closePrice as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From MarketIndex
        Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 2 and ticker = indexTicker
         ),
 fridaysIndex as (
         Select ticker, date_, closePrice as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
         From MarketIndex
         Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 6 and ticker = indexTicker
         ),
 mondaysBond as (
         Select ticker, date_, price as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
         From Bond
         Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 2 and ticker = bondTicker
         ),  
 fridaysBond as (
         Select ticker, date_, price as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
         From Bond
         Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 6 and ticker = bondTicker
         ),
 greenWeeksIndex as (
         Select m.ticker, startPrice, endPrice, m.yearWeek as 'yearWeek', m.date_ as 'monday_date'
         From mondaysIndex as m, fridaysIndex as f
         Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice < endPrice
         ),
 redWeeksBond as (
         Select m.ticker, startPrice, endPrice, m.yearWeek as 'yearWeek', m.date_ as 'monday_date'
         From mondaysBond as m, fridaysBond as f
         Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice > endPrice
        )
 Select g.yearWeek, g.monday_date
 From greenWeeksIndex as g, redWeeksBond as r
 Where g.yearWeek = r.yearWeek;
END; //

DELIMITER ;
