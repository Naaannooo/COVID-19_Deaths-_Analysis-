select *
from project1..covidDeathsYT
where continent is not null
order by 3,4 

--select *
--from project1..covidVaccinations
--order by 3,4 


-- select data that we are giong to use it

select location, date, total_cases, total_deaths, population 
from project1..covidDeathsYT
order by 1,2

-- looking at total cases vs total deaths 
--shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths* 100.0/total_cases) as DeathPrecentage
from project1..covidDeathsYT
where location like '%africa%'
order by 1,2

-- looking at the total cases vs population
--shows what percentage of population got covid  

select location, date,  population,total_cases, (total_cases* 100.0/population) as PrecentPopulationInfected
from project1..covidDeathsYT
--where location like '%africa%'
order by 1,2


--looking at countries with Highest Infection Rate compared to Population 
select location, population,max(total_cases)as HighestInfectioncount, max((total_cases* 100.0/population)) as PrecentPopulationInfected
from project1..covidDeathsYT
--where location like '%africa%'
group by Location, population
order by PrecentPopulationInfected desc


-- showing countries with Highest Death bcount per Population 

select location,max(cast(total_deaths as int))as totalDeathCount
from project1..covidDeathsYT
where continent is not null
group by Location
order by totalDeathCount desc




--Let's Break Things Down By Continent

-- showing the contintent with the highest death count per population 

select continent, max(cast(total_deaths as int))as highestcases
from project1..covidDeathsYT
where continent is not null
group by continent
order by hig
hestcases  desc


-- Global Numbers 


SELECT
    date,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(ISNULL(new_deaths,0) AS INT)) AS TotalDeaths,
    SUM(CAST(ISNULL(new_deaths,0) AS INT)) * 100.0 /
    NULLIF(SUM(new_cases),0) AS DeathPercentage
FROM project1..covidDeathsYT
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
FROM project1..covidDeathsYT dea
JOIN project1..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3;

-- use CTE 

WITH PopvsVac (
    continent,
    location,
    date,
    population,
    new_vaccinations,
    RollingPeopleVaccinated
)
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(BIGINT, new_vaccinations))
            OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
            AS RollingPeopleVaccinated
    FROM project1..covidDeathsYT dea
    JOIN project1..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT * ,(rollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Create Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    continent nvarchar(255),
    location nvarchar(255),
    Date datetime,
    population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    TRY_CONVERT(numeric, dea.population),
    TRY_CONVERT(numeric, vac.new_vaccinations),
    SUM(TRY_CONVERT(BIGINT, vac.new_vaccinations))
        OVER (PARTITION BY dea.location ORDER BY dea.date)
FROM project1..covidDeathsYT dea
JOIN project1..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


SELECT *,
    (RollingPeopleVaccinated * 100.0 / NULLIF(population,0))
    AS PercentPopulationVaccinated
FROM #PercentPopulationVaccinated;


-- Creating view to store data for later visualizations

DROP VIEW IF EXISTS PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(TRY_CONVERT(BIGINT, vac.new_vaccinations))
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM project1..covidDeathsYT dea
JOIN project1..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *
FROM PercentPopulationVaccinated;


