-- 1) All values in the new tuple corresponding to foreign keys reference existing tuples in the other tables
Insert Into Company Values
('Philip Kim', 'Male', 'Asian', 420, 'PLTR', 'Palantir', 'XLK', 69);

-- 2) When at least one of the values in the new tuple doesn’t reference an existing tuple in another table,
--    so you need to insert a tuple in the other table before you can proceed.
Insert Into SectorETF Values
('ETFF', '2025-01-01', 100, 102, 98, 101, 1000);
Insert Into Company Values
('Miles Lee', 'Male', 'Asian', 69, 'SPY', 'SPDR S&P 500 ETF Trust', 'ETFF', 420);

-- Write appropriate SQL statement(s) to delete a specified tuple from a table in your database
Delete From Company Where name = 'Philip Kim' and ticker = 'PLTR';
Delete From Company Where name = 'Miles Lee' and ticker = 'SPY';