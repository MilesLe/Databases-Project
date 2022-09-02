-- Jeremy Zhou, jzhou83
-- Miles Lee, mlee276

DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS MarketIndex;
DROP TABLE IF EXISTS Bond;
DROP TABLE IF EXISTS SectorETF;
DROP TABLE IF EXISTS OptionVolume;

CREATE TABLE MarketIndex (
  ticker        VARCHAR(5),
  date_         DATE,
  openPrice     REAL,
  high          REAL,
  low           REAL,
  closePrice    REAL,
  volume        INT,
  PRIMARY KEY(ticker, date_)
);

CREATE TABLE Bond (
  ticker        VARCHAR(5),
  date_         DATE,
  price         REAL,
  openPrice     REAL,
  high          REAL,
  low           REAL,
  changePercent REAL,
  PRIMARY KEY(ticker, date_)
);

CREATE TABLE SectorETF (
  ticker        VARCHAR(5),
  date_         DATE,
  openPrice     REAL,
  high          REAL,
  low           REAL,
  closePrice    REAL,
  volume        INT,
  PRIMARY KEY(ticker, date_)
);

CREATE TABLE OptionVolume (
  ticker        VARCHAR(5),
  date_         DATE,
  callVol       INT,
  putVol        INT,
  putCallRatio  REAL,
  PRIMARY KEY(ticker, date_)
);

CREATE TABLE Company (
  name          VARCHAR(63),
  gender        VARCHAR(6),
  race          VARCHAR(10),
  age           INT,
  ticker        VARCHAR(5),
  company       VARCHAR(63),
  sector        VARCHAR(5),
  marketCap     REAL,
  PRIMARY KEY(ticker, name),
  FOREIGN KEY(sector) REFERENCES SectorETF(ticker)-- ON DELETE CASCADE  ON UPDATE CASCADE
);

LOAD DATA LOCAL INFILE '/Users/zhou/Downloads/MarketIndex.txt' INTO TABLE MarketIndex
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ticker, date_, openPrice, high, low, closePrice, volume);

LOAD DATA LOCAL INFILE '/Users/zhou/Downloads/Bond.txt' INTO TABLE Bond
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ticker, date_, price, openPrice, high, low, changePercent);

LOAD DATA LOCAL INFILE '/Users/zhou/Downloads/SectorETF.txt' INTO TABLE SectorETF
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ticker, date_, openPrice, high, low, closePrice, volume);

LOAD DATA LOCAL INFILE '/Users/zhou/Downloads/OptionVolume.txt' INTO TABLE OptionVolume
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ticker, date_, callVol, putVol, putCallRatio);

LOAD DATA LOCAL INFILE '/Users/zhou/Downloads/Company.txt' INTO TABLE Company
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(name, gender, race, age, ticker, company, sector, marketCap);