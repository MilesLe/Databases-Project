-- Q14.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q14 //

CREATE PROCEDURE Q14(IN inputTicker VARCHAR(255), IN volume INTEGER)
BEGIN
  With MondayPricesM as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, openPrice, date_
        From MarketIndex
        Where dayofweek(date_) = 2
  ),
  FridayPricesM as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, closePrice, date_
        From MarketIndex
        Where dayofweek(date_) = 6
  ),
  PercentDiffPricesM as (
        Select YEARWEEK(M.date_) as 'yearWeek', M.ticker as 'ticker', (closePrice - openPrice)/openPrice*100 as 'percentDiff'
        From MondayPricesM as M, FridayPricesM as F
        Where M.ticker = F.ticker and M.yearWeek = F.yearWeek
  ),
  MondayPricesS as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, openPrice, date_
        From SectorETF
        Where dayofweek(date_) = 2
  ),
  FridayPricesS as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, closePrice, date_
        From SectorETF
        Where dayofweek(date_) = 6
  ),
  PercentDiffPricesS as (
        Select M.date_ as 'monday_date', YEARWEEK(M.date_) as 'yearWeek', M.ticker as 'ticker', (closePrice - openPrice)/openPrice*100 as 'percentDiff'
        From MondayPricesS as M, FridayPricesS as F
        Where M.ticker = F.ticker and M.yearWeek = F.yearWeek
  )
  Select monday_date
  From PercentDiffPricesM as M, PercentDiffPricesS as S, OptionVolume
  Where callVol >= volume and M.yearWeek = S.yearWeek and M.ticker = 'SPY' and S.percentDiff > M.percentDiff and S.ticker = inputTicker;
END; //

DELIMITER ;
