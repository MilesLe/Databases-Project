-- Q13.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q13 //

CREATE PROCEDURE Q13(IN threshold DOUBLE)
BEGIN
  With mondayPrices as (
    Select YEARWEEK(date_) as 'yearWeek', dayofweek(date_) as 'weekday', ticker, openPrice as 'startPrice', date_
    From MarketIndex
    Where dayofweek(date_) = 2
    ),
	fridayPrices as (
    Select YEARWEEK(date_) as 'yearWeek', dayofweek(date_) as 'weekday', ticker, closePrice as 'endPrice', date_
    From MarketIndex
    Where dayofweek(date_) = 6
    ),
	percentDiffPrices as (
    Select YEARWEEK(m.date_) as 'yearWeek', dayofweek(m.date_) as 'weekday', m.ticker, (f.endPrice - m.startPrice)/m.startPrice as 'percentDiff'
    From mondayPrices as m, fridayPrices as f
    Where m.ticker = f.ticker and m.yearWeek = f.yearWeek
    ),
	spy as (
    Select count(distinct s.yearWeek) as 'spy week count'
    From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
    Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
            and s.ticker = 'spy' and q.ticker = 'qqq' and d.ticker = 'dia'
            and (s.percentDiff - q.percentDiff > threshold) and (s.percentDiff - d.percentDiff > threshold)
    ),
	qqq as (
	  Select count(distinct s.yearWeek) as 'qqq week count'
	  From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
	  Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
	          and s.ticker = 'qqq' and q.ticker = 'spy' and d.ticker = 'dia'
	          and (s.percentDiff - q.percentDiff > threshold) and (s.percentDiff - d.percentDiff > threshold)
	  ),
	dia as (
	  Select count(distinct s.yearWeek) as 'dia week count'
	  From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
	  Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
	          and s.ticker = 'dia' and q.ticker = 'qqq' and d.ticker = 'spy'
	          and (s.percentDiff - q.percentDiff > threshold) and (s.percentDiff - d.percentDiff > threshold)
	  )
	Select *
	From spy, qqq, dia;
END; //

DELIMITER ;
