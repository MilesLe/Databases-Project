-- Q4.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q4 //

CREATE PROCEDURE Q4(IN inputTicker VARCHAR(255), IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  With TopDaysInRange As (
    Select date_, openPrice, closePrice
    From MarketIndex
    Where date_ > weekDateStart And date_ < weekDateEnd And ticker = inputTicker
    Order by volume Desc Limit 10
  )
  Select *
  From TopDaysInRange
  Where closePrice > openPrice;
END; //

DELIMITER ;
