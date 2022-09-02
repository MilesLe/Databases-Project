-- Q11Index.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q11Index //

CREATE PROCEDURE Q11Index(IN ticker VARCHAR(255), IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  Select m.ticker, dayofweek(m.date_) as 'weekDay', avg((m.closePrice - m.openPrice)/m.openPrice*100) as 'avgPricePercentDiff', avg(putCallRatio) as 'average put-call ratio'
  From MarketIndex as m, OptionVolume as o
  Where m.date_ > weekDateStart and m.date_ < weekDateEnd and m.ticker = o.ticker and m.date_ = o.date_ and m.ticker = ticker
  Group by dayofweek(m.date_);
END; //

DELIMITER ;
