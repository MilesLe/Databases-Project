-- Q2.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q2 //

CREATE PROCEDURE Q2(IN tickerInput VARCHAR(255))
BEGIN
  With greenDaysPerETF as (
    Select date_, count(ticker) as 'numGreen'
    From SectorETF as s
    Where closePrice > openPrice
    Group by date_
  ),
  daysWithOneRed as (
    Select date_, numGreen
    From greenDaysPerETF as g
    Where numGreen = (Select count(distinct ticker)-1
                      From SectorETF)
  )
  Select s.date_, ticker, s.closePrice, s.openPrice
  From daysWithOneRed as d, SectorETF as s
  Where d.date_ = s.date_ AND s.closePrice < s.openPrice AND s.ticker = tickerInput;
END; //

DELIMITER ;
