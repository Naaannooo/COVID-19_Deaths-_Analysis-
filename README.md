# PorfolioProjects
# COVID-19 Data Analysis Using SQL

## Project Overview

This project analyzes COVID-19 deaths and vaccination data using SQL.
The goal of this project is to explore global COVID-19 trends, including cases, deaths, death percentages, and vaccination progress.

This project was created as a beginner data analysis project to practice SQL skills such as data exploration, aggregation, joins, window functions, temporary tables, and views.

## Tools Used

* SQL Server
* DBeaver (SQL Client)
* Microsoft Excel (Data Source)

## Dataset

The dataset contains COVID-19 information including:

* Countries and continents
* Population data
* Total COVID-19 cases
* Total COVID-19 deaths
* New cases
* Vaccination data
* New vaccinations

## Analysis Performed

The following analyses were completed:

* Total cases and total deaths by location
* Death percentage calculation
* Countries with the highest COVID-19 cases and deaths
* COVID-19 trends over time
* Vaccination progress by country
* Percentage of population vaccinated
* Rolling vaccination counts using SQL window functions

## SQL Skills Demonstrated

* SELECT statements
* Filtering with WHERE
* GROUP BY and aggregate functions
* ORDER BY
* JOIN operations
* Common Table Expressions (CTEs)
* Temporary Tables
* SQL Views
* Window Functions
* Data type conversion

## Example Analysis

Calculated the percentage of population vaccinated using a rolling count:

```sql
SUM(new_vaccinations) OVER (
PARTITION BY location 
ORDER BY date
)
```

## Project Purpose

This project demonstrates my ability to use SQL for data analysis and transform raw datasets into meaningful insights.

## Future Improvements

* Create visual dashboards using Power BI
* Perform additional data cleaning
* Add more advanced SQL analysis
* Explore trends using Python
