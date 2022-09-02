-- Q15.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q15 //

CREATE PROCEDURE Q15(IN indexTicker VARCHAR(255), IN bondTicker VARCHAR(255))
BEGIN
  With FirstDayOfMonth as (
        Select MonthName(date_) as 'month_', Year(date_) as 'year_', EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', min(date_) as 'firstDay', openPrice
        From MarketIndex
        Where ticker = indexTicker
        Group by EXTRACT(YEAR_MONTH FROM date_)
  ),
  LastDayOfMonth as (
        Select EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', max(date_) as 'lastDay', closePrice
        From MarketIndex
        Where ticker = indexTicker
        Group by EXTRACT(YEAR_MONTH FROM date_)
  ),
  MonthlyIndexReturns as (
        Select F.month_, F.year_, F.yearMonth as 'yearMonth', (closePrice - openPrice) / openPrice * 100 as 'rets'
        From FirstDayOfMonth as F, LastDayOfMonth as L
        Where F.yearMonth = L.yearMonth
  ),
  MonthlyBondReturns as (
        Select EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', price/12 as 'price'
        From Bond
        Where ticker = bondTicker And EXTRACT(DAY FROM date_) = 1
  ) 
  Select I.month_, I.year_ 
  From MonthlyIndexReturns as I, MonthlyBondReturns as B
  Where I.yearMonth = B.yearMonth And B.price > I.rets;
END; //

DELIMITER ;
