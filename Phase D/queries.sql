-- Miles Lee - mlee276
-- Jeremy Zhou - jzhou83

-- Q: In week __2017-02-14_, which sector performed the best? What was the price at the end of week and the average volume?
With mondays as (
        Select ticker, date_, closePrice as startPrice
        From SectorETF 
        Where YEARWEEK(date_) = YEARWEEK('2017-02-14') and dayofweek(date_) = 2
        ),
fridays as (
        Select ticker, date_, closePrice as endPrice
        From SectorETF 
        Where YEARWEEK(date_) = YEARWEEK('2017-02-14') and dayofweek(date_) = 6
        ),
bestSector as (
        Select m.ticker, max(endPrice - startPrice) as 'bestDiff', endPrice
        From mondays as m, fridays as f
        Where m.ticker = f.ticker
        )
Select s.ticker, avg(s.volume) as 'average volume', b.endPrice
From bestSector as b, SectorETF as s
Where b.ticker = s.ticker

-- Q: On what days were all the sectors green except for the _xlb__ sector?
With greenDaysPerETF as (
        Select date_, count(ticker) as 'numGreen'
        From SectorETF as s
        Where closePrice > openPrice
        Group by date_
        ),
daysWithOneRed as (
        Select date_, numGreen
        From greenDaysPerETF as g
        Where numGreen = 3
        ),
redSectorPerDate as (
        Select s.date_, ticker, s.closePrice, s.openPrice
        From daysWithOneRed as d, SectorETF as s
        Where d.date_ = s.date_ AND s.closePrice < s.openPrice AND s.ticker = 'xlb'
        )
Select *
From redSectorPerDate
 
 
-- Q: On what days did the __XLI_ sector increase while the _XLK__ sector decreased?
Select S1.date_
From SectorETF As S1, SectorETF as S2
Where S1.date_ = S2.date_ And S1.ticker = 'XLI' And S1.closePrice > S1.openPrice And S2.ticker = 'XLK' And S2.closePrice < S2.openPrice
 

-- Q: For market index _spy_, of the top _3_ number of days between _2017-02-05_ and _2017-03-10_ dates with the greatest volume, which dates were green? What were the opening and closing prices on those days?
With TopDaysInRange As (
Select date_, openPrice, closePrice
From MarketIndex
Where date_ > '2017-02-05' And date_ < '2017-03-10' And ticker = 'spy'
Order by volume Desc Limit 3
)
Select *
From TopDaysInRange
Where closePrice > openPrice
 

-- Q: What were the top _5__ days between __2017-01-13_ and __2017-03-18_ dates that had the largest change in price in _spy__ market index? How many of these days were green? How many red?
Drop View If Exists TopChanges;
 
Create View TopChanges As
Select date_, openPrice, closePrice
From MarketIndex
Where date_ > '2017-01-13' And date_ < '2017-03-18' And ticker = 'spy'
Order by Abs(closePrice - openPrice) Desc Limit 5;
 
Select date_ as 'green days'
From TopChanges
Where closePrice >= openPrice;
 
Select date_ as 'red days'
From TopChanges
Where openPrice > closePrice;
 

-- Q: Of what weeks between _2017-01-14_ and _2017-03-14_ dates were the _US10Y__ bond _red__ (RED/green) and the __spy_ index __green__ (red/GREEN)?
With mondaysIndex as (
        Select ticker, date_, closePrice as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From MarketIndex
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-14') and YEARWEEK(date_) >= YEARWEEK('2017-01-14')) and dayofweek(date_) = 2 and ticker = 'spy'
        ),
fridaysIndex as (
        Select ticker, date_, closePrice as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From MarketIndex
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-14') and YEARWEEK(date_) >= YEARWEEK('2017-01-14')) and dayofweek(date_) = 6 and ticker = 'spy'
        ),
mondaysBond as (
        Select ticker, date_, price as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-14') and YEARWEEK(date_) >= YEARWEEK('2017-01-14')) and dayofweek(date_) = 2 and ticker = 'US10Y'
        ),  
fridaysBond as (
        Select ticker, date_, price as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-14') and YEARWEEK(date_) >= YEARWEEK('2017-01-14')) and dayofweek(date_) = 6 and ticker = 'US10Y'
        ),
greenWeeksIndex as (
        Select m.ticker, startPrice, endPrice, m.yearWeek, m.date_ as 'monday_date'
        From mondaysIndex as m, fridaysIndex as f
        Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice < endPrice
        ),
redWeeksBond as (
        Select m.ticker, startPrice, endPrice, m.yearWeek, m.date_ as 'monday_date'
        From mondaysBond as m, fridaysBond as f
        Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice > endPrice
        )
Select g.yearWeek, g.monday_date
From greenWeeksIndex as g, redWeeksBond as r
Where g.yearWeek = r.yearWeek


-- Q: Between _2017-01-05_ and _2017-03-18'_ dates, of which days with a put/call ratio greater than __1.5_ did __'spy'_ index go down?
Select M.date_
From MarketIndex as M, OptionVolume as O
Where M.date_ = O.date_ And M.date_ > '2017-01-05' And M.date_ < '2017-03-18' And M.ticker = 'spy' And O.ticker = 'spy' And putCallRatio > 1.5 And closePrice < openPrice


-- Q: Between _2017-01-14__ and _2017-03-17__ dates, select the sector with the greatest percent increase in price. Of that sector, what is the number of male and female CEOs?
With priceStartSectors as (
        Select ticker, date_, closePrice as 'startPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK('2017-01-14')
        ),
priceEndSectors as (
        Select ticker, date_, closePrice as 'endPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK('2017-03-17')
        ),
priceMaxPercentIncreaseSectors as (
        Select s.ticker, max((endPrice - startPrice)/startPrice) as 'greatest_increase_of_price_of_sectors'
        From priceStartSectors as s, priceEndSectors as e
        )
 
Select c.sector,count(c.gender) as 'num males', 5 - count(c.gender) as 'num females'
From priceMaxPercentIncreaseSectors as p, Company as c
Where p.ticker = c.sector and c.gender = 'male'
Group By c.sector
 

-- Q: Between _2017-01-14__ and __2017-03-17_ dates of the sectors which increased in value, which companies have CEOs who are non white or non male? 
With priceStartSectors as (
        Select ticker, date_, closePrice as 'startPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK('2017-01-14')
        ),
priceEndSectors as (
        Select ticker, date_, closePrice as 'endPrice'
        From SectorETF
        Where YEARWEEK(date_) = YEARWEEK('2017-03-17')
        ),
greenSectors as (
        Select s.ticker
        From priceStartSectors as s, priceEndSectors as e
        Where s.ticker = e.ticker and s.startPrice < e.endPrice
        Group by s.ticker
        )
Select c.sector, c.company
From greenSectors as g, Company as c
Where g.ticker = c.sector and (c.gender != 'Male' or c.race != 'White')


-- Q: Over all weeks between _2017-01-17__ and _2017-03-17__ where _US10Y__ bond is __red_ (red/green), for each sector how many of those weeks had an average put/call ratio above __1_?
With mondaysBond as (
        Select ticker, date_, price as 'startPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-17') and YEARWEEK(date_) >= YEARWEEK('2017-01-17')) and dayofweek(date_) = 2 and ticker = 'US10Y'
        ),  
fridaysBond as (
        Select ticker, date_, price as 'endPrice', YEARWEEK(date_) as 'yearWeek',  dayofweek(date_) as 'weekDay'
        From Bond
        Where (YEARWEEK(date_) <= YEARWEEK('2017-03-17') and YEARWEEK(date_) >= YEARWEEK('2017-01-17')) and dayofweek(date_) = 6 and ticker = 'US10Y'
        ),
redWeeksBond as (
        Select m.ticker, startPrice, endPrice, m.yearWeek, m.date_ as 'monday_date'
        From mondaysBond as m, fridaysBond as f
        Where m.ticker = f.ticker and m.yearWeek = f.yearWeek and startPrice > endPrice
        ),
avgWeekRatioPutCallVolume as (
        Select o.ticker, o.date_ as 'monday_date', r.yearWeek, avg(o.putCallRatio) as 'average_put_call_ratio'
        From OptionVolume as o, redWeeksBond as r
        Where r.yearWeek = YEARWEEK(o.date_)
        Group By o.ticker
        )
Select *
From avgWeekRatioPutCallVolume
Where average_put_call_ratio > 1.3


-- Q: Between _2017-01-17__ and __2017-03-17_ dates, for each day of the week what is the average SPY index and all sector ETF price percent change, volume, and option volume ratio?
-- Note: there are two queries here.
Select m.ticker, dayofweek(m.date_) as 'weekDay', avg((m.closePrice - m.openPrice)/m.openPrice) as 'avgPricePercentDiff', avg(m.volume) as 'average volume', avg(putCallRatio) as 'average put-call ratio'
From MarketIndex as m, OptionVolume as o
Where (YEARWEEK(m.date_) <= YEARWEEK('2017-03-17') and YEARWEEK(m.date_) >= YEARWEEK('2017-01-17')) and m.ticker = 'SPY' and m.ticker = o.ticker and m.date_ = o.date_
Group by dayofweek(m.date_);
 
-- Note: results are inaccurate for the "-small" data files since many magnitudes more of data is required for accurate results. Implementing such a larger file would defeat the purpose of using small files we can understand well to test our queries. So, this below query is reserved for the larger files. 
Select m.ticker, dayofweek(m.date_) as 'weekDay', avg((m.closePrice - m.openPrice)/m.openPrice) as 'avgPricePercentDiff', avg(m.volume) as 'average volume', avg(putCallRatio) as 'average put-call ratio'
From SectorETF as m, OptionVolume as o
Where (YEARWEEK(m.date_) <= YEARWEEK('2005-11-26') and YEARWEEK(m.date_) >= YEARWEEK('2005-11-14')) and m.ticker = o.ticker and m.date_ = o.date_
Group by dayofweek(m.date_);



-- Q: On all the days which are red for __spy_ index, what percent of days had an average percent increase in all bonds greater than _0__ percent?
With redIndex as (
        Select ticker, date_
        From MarketIndex
        Where ticker = 'spy' and closePrice < openPrice
        ),
countAllBondDays as (
        Select count(distinct date_) as 'num_of_days'
        From Bond
        )
Select b.ticker, count(distinct b.date_)/c.num_of_days*100 as 'percent of days where bond percent price increase is above 0%'
From countAllBondDays as c, redIndex as r, Bond as b
Where b.date_ = r.date_ and b.changePercent > 0
Group by b.ticker


-- Q: For each market index, how many weeks did the index outperform the other two by greater than __0.0001_? Note: this one takes a while to run.
With mondayPrices as (
        Select YEARWEEK(date_) as 'yearWeek', dayofweek(date_) as 'weekday', ticker, openPrice as 'startPrice', date_
        From MarketIndex
        Where dayofweek(date_) = 3
        ),
fridayPrices as (
        Select YEARWEEK(date_) as 'yearWeek', dayofweek(date_) as 'weekday', ticker, closePrice as 'endPrice', date_
        From MarketIndex
        Where dayofweek(date_) = 6
        ),
percentDiffPrices as (
        Select YEARWEEK(m.date_) as 'yearWeek', dayofweek(m.date_) as 'weekday', m.ticker, (f.endPrice - m.startPrice)/m.startPrice as 'percentDiff'
        From mondayPrices as m, fridayPrices as f
        Where m.ticker = f.ticker and m.yearWeek = f.yearWeek
        ),
spy as (
        Select count(distinct s.yearWeek) as 'spy week count'
        From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
        Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
                and s.ticker = 'spy' and q.ticker = 'qqq' and d.ticker = 'dia'
                and (s.percentDiff - q.percentDiff > 0.0001) and (s.percentDiff - d.percentDiff > 0.0001)
        ),
qqq as (
        Select count(distinct s.yearWeek) as 'qqq week count'
        From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
        Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
                and s.ticker = 'qqq' and q.ticker = 'spy' and d.ticker = 'dia'
                and (s.percentDiff - q.percentDiff > 0.0001) and (s.percentDiff - d.percentDiff > 0.0001)
        ),
dia as (
        Select count(distinct s.yearWeek) as 'dia week count'
        From percentDiffPrices as s, percentDiffPrices as q, percentDiffPrices as d
        Where s.yearWeek = q.yearWeek and s.yearWeek = d.yearWeek 
                and s.ticker = 'dia' and q.ticker = 'qqq' and d.ticker = 'spy'
                and (s.percentDiff - q.percentDiff > 0.0001) and (s.percentDiff - d.percentDiff > 0.0001)
        )
Select *
From spy, qqq, dia



-- Q: Of _xle__ ticker when call volume is greater than _60000__, list the days where the next week had a greater return than __spy_ index.
With MondayPricesM as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, openPrice, date_
        From MarketIndex
        Where dayofweek(date_) = 3
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
        Where dayofweek(date_) = 3
),
FridayPricesS as (
        Select YEARWEEK(date_) as 'yearWeek', ticker, closePrice, date_
        From SectorETF
        Where dayofweek(date_) = 6
),
PercentDiffPricesS as (
        Select YEARWEEK(M.date_) as 'yearWeek', M.ticker as 'ticker', (closePrice - openPrice)/openPrice*100 as 'percentDiff'
        From MondayPricesS as M, FridayPricesS as F
        Where M.ticker = F.ticker and M.yearWeek = F.yearWeek
)
Select date_, S.percentDiff, P.percentDiff
From PercentDiffPricesM as P, PercentDiffPricesS as S, OptionVolume as O
Where callVol >= 60000 and P.ticker = 'XLE' and P.ticker = S.ticker and S.percentDiff > P.percentDiff and S.ticker = ‘spy’


-- Q: List the months where the _US10YR_ bond outperformed the _spy__ index.
With FirstDayOfMonth as (
        Select EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', min(date_) as 'firstDay', openPrice
        From MarketIndex
        Where ticker = 'spy'
        Group by EXTRACT(YEAR_MONTH FROM date_)
),
LastDayOfMonth as (
        Select EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', max(date_) as 'lastDay', closePrice
        From MarketIndex
        Where ticker = 'spy'
        Group by EXTRACT(YEAR_MONTH FROM date_)
),
MonthlyIndexReturns as (
        Select F.yearMonth as 'yearMonth', (closePrice - openPrice) / openPrice * 100 as 'rets'
        From FirstDayOfMonth as F, LastDayOfMonth as L
        Where F.yearMonth = L.yearMonth
),
MonthlyBondReturns as (
        Select EXTRACT(YEAR_MONTH FROM date_) as 'yearMonth', price/12 as 'price'
        From Bond
        Where ticker = 'US10YR' And EXTRACT(DAY FROM date_) = 1
)
Select I.yearMonth as 'yearMonth', B.price, I.rets
From MonthlyIndexReturns as I, MonthlyBondReturns as B
Where I.yearMonth = B.yearMonth And B.price > I.rets
