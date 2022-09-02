-- Q3.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q3 //

CREATE PROCEDURE Q3(IN ticker1 VARCHAR(255), IN ticker2 VARCHAR(255), IN yearNum VARCHAR(255))
BEGIN
  Select count(S1.date_), MONTH(S1.date_) as 'month num'
  From SectorETF As S1, SectorETF as S2
  Where S1.date_ = S2.date_ And S1.ticker = ticker1 And S1.closePrice > S1.openPrice And S2.ticker = ticker2 And S2.closePrice < S2.openPrice AND YEAR(S1.date_) = yearNum
  Group By MONTH(S1.date_);
END; //

DELIMITER ;
