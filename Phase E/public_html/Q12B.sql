-- Q12B.sql

DELIMITER //

DROP PROCEDURE IF EXISTS Q12B //

CREATE PROCEDURE Q12B(IN indexTicker VARCHAR(255), IN bondTicker VARCHAR(255), IN percent DOUBLE)
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
  Select b.date_, b.changePercent
  From countAllBondDays as c, redIndex as r, Bond as b
  Where b.date_ = r.date_ and b.changePercent > percent and b.ticker = bondTicker;
END; //

DELIMITER ;
