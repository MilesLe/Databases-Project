-- Q7.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q7 //

CREATE PROCEDURE Q7(IN ticker VARCHAR(255), IN ratio DOUBLE, IN weekDateStart VARCHAR(255), IN weekDateEnd VARCHAR(255))
BEGIN
  Select M.date_
  From MarketIndex as M, OptionVolume as O
  Where M.date_ = O.date_ And M.date_ > weekDateStart And M.date_ < weekDateEnd And M.ticker = 'spy' And O.ticker = ticker And putCallRatio > ratio And closePrice < openPrice;
END; //

DELIMITER ;
