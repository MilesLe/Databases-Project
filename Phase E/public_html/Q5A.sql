-- Q5A.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q5A //

CREATE PROCEDURE Q5A(IN inputTicker VARCHAR(255), IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  With TopChanges As (
        Select date_, openPrice, closePrice
        From MarketIndex
        Where date_ > weekDateStart And date_ < weekDateEnd And ticker = inputTicker
        Order by Abs(closePrice - openPrice) Desc Limit 5
        )
  Select date_ as 'green days'
  From TopChanges
  Where closePrice >= openPrice;
END; //

DELIMITER ;
