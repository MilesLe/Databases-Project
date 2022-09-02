**Phase E is the final version of the project. Phase A to D are developmental phases of the project.**

Install notes: 
- Before running setup.sql and setup-small.sql, the user must update the file pathways of the datafiles. 
- The user must add all the SQL stored procedures (about 1 for each question, 2-3 for some questions) before the .html file will properly execute the queries.

We also made a HTML/PHP website to interact with the SQL queries we made. This website is in public_html/jzhou83_mlee276.html


**Process**

1) Briefly document the process (which data came from which URL and in what format, what downloaded columns you needed to remove, which downloaded files contained duplicate values or anomalies and how you removed them, what splitting of files was needed, etc.)

We searched for data according to these categories:

\- Each category correlates to a relation in our relation schema.

- Bond yield (relation: Bond)
  - Downloaded data from these websites, which correlate to each type of treasury bond we are interested in.
    - <https://www.investing.com/rates-bonds/u.s.-5-year-bond-yield-historical-data>
    - <https://www.investing.com/rates-bonds/u.s.-6-month-bond-yield-historical-data>
    - <https://www.investing.com/rates-bonds/u.s.-10-year-bond-yield-historical-data>
    - Dates: 4/05/2011 to 4/05/2021
  - Needed to sign up for a free account in order to download data for free.
  - We added a “ticker” column with the duration of the bond. Then, we combined all three bond data files using python.
  - Converted date format to YYYY-MM-DD using python.
    - relation\_processing.ipynb located in dbase\_setup folder.
- Stock option volume (relation: OptionVolume)
  - Downloaded data from this website -
    - [https://www.theocc.com/Market-Data/Market-Data-Reports/Volume-and-O pen-Interest/Volume-Query](https://www.theocc.com/Market-Data/Market-Data-Reports/Volume-and-Open-Interest/Volume-Query)
  - In order to download the daily stock data for free, we needed to program a python script to download option calls and put volume for specific stock tickers and dates via HTTP calls for free. This script is available in our submission.
    - get\_option\_volume.ipynb located in dbase\_setup folder.
  - Converted date format to YYYY-MM-DD using python.
    - relation\_processing.ipynb located in dbase\_setup folder.
  - We shifted the OptionVolume dataset backwards by 6 years in order to align this data with the dates of our other datasets.
- Stock price and order volume (relation: SectorETF and MarketIndex)
  - Downloaded data from this website
    - [https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stoc ks-etfs](https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs)
  - Downloaded all the stock historical data files.
  - We removed the “open interest” column since all the values are zero.
  - For all sector ETF data files, we added a “ticker” column then appended them together using python.
    - Same thing was done for market index data files.
    - relation\_processing.ipynb located in dbase\_setup folder.
- Identifying ETFs (by sector) and Companies (relation: Company)
  - Searched online the ETF sectors in SPDR
  - Per sector, found the ETF’s top five holdings (companies)
  - Researched the ceo, ceo demographics, and market cap per company.

**A few Successes**

One particular query we were proud of was question 11. First, we created tables of the average price change and put/call ratio for each weekday, for both the given index and all sectors. This required executing another small query beforehand to get all the tickers, then looping through it in php. We created a multi-column bar chart of the average percent price change per weekday, to highlight average price change in particular and answer questions like “is Tuesday more green than Monday”. We pulled data from both SectorETF.txt, MarketIndex.txt, and OptionVolume.txt to create the data in the tables. The graph is an example run; it showed that in the time frame selected, Monday was the most red and Tuesday and Wednesday were the most green!

![](Aspose.Words.7d33c44d-aad9-4884-9f43-b22047a091e6.001.jpeg)

Another thing we were proud of was pulling the option volume data. Option data was difficult to find online, but we found that <https://marketdata.theocc.com> gave good data but only for specific dates at a time. However, they provided an API we could use to pull data, so we wrote a python script to pull option volume data using HTTP requests for all the tickers and dates we wanted and throw it into a csv file. The code is on the next page!


<img width="686" alt="Screen Shot 2022-09-01 at 9 33 58 PM" src="https://user-images.githubusercontent.com/15742321/188040239-c7bed8ff-d78f-4810-8879-9f35861b8d28.png">


