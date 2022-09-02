-- Q10.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q10 //

CREATE PROCEDURE Q10(IN inputTicker VARCHAR(255), IN ratio DOUBLE, IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  With mondaysBond as (
        Select ticker, date_, price as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 2 and ticker = inputTicker
        ),
  fridaysBond as (
        Select ticker, date_, price as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where date_ > weekDateStart and date_ < weekDateEnd and dayofweek(date_) = 6 and ticker = inputTicker
        ),
  redWeeksBond as (
        Select m.ticker, m.yearWeek, m.date_ as 'monday_date'
        From mondaysBond as m, fridaysBond as f
        Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice > endPrice
        ),
  avgWeekRatioPutCallVolume as (
        Select o.ticker, r.yearWeek, round(avg(o.putCallRatio), 2) as 'average_put_call_ratio'
        From OptionVolume as o, redWeeksBond as r
        Where r.yearWeek = YEARWEEK(o.date_) and o.putCallRatio > ratio
        Group By o.ticker, r.yearWeek
        )
  Select ticker, count(yearWeek) as 'num weeks', average_put_call_ratio
  From avgWeekRatioPutCallVolume
  Group By ticker;
END; //

DELIMITER ;
