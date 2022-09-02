-- Q12A.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q12A //

CREATE PROCEDURE Q12A(IN indexTicker VARCHAR(255), IN bondTicker VARCHAR(255), IN percent DOUBLE)
BEGIN
  With redIndex as (
        Select ticker, date_
        From MarketIndex
        Where ticker = indexTicker and closePrice < openPrice
        ),
  countAllBondDays as (
        Select count(distinct b_.date_) as 'num_of_days'
        From Bond as b_, redIndex as r_
        )
  Select (count(b.date_)/c.num_of_days)*100 as 'percentDaysAboveThreshold'
  From countAllBondDays as c, redIndex as r, Bond as b
  Where b.date_ = r.date_ and b.changePercent > percent and b.ticker = bondTicker;
END; //

DELIMITER ;
