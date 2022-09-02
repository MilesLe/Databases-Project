-- Q11Ticker.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q11Ticker //

CREATE PROCEDURE Q11Ticker()
BEGIN
  Select Distinct ticker
  From SectorETF;
END; //

DELIMITER ;
